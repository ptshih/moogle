//
//  CheckinHereViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CheckinHereViewController.h"
#import "Constants.h"
#import "MoogleDataCenter.h"

#import "ASIHTTPRequest.h"
#import "RemoteRequest.h"
#import "RemoteOperation.h"

#import "LocationManager.h"
#import "Place.h"

#import "NearbyPickerViewController.h"

@interface CheckinHereViewController (Private)

- (void)updatePlaceLabels;
- (void)postCheckin;
- (void)postMoogleCheckin:(NSString *)checkinId;

@end

@implementation CheckinHereViewController

@synthesize checkinMessage = _checkinMessage;
@synthesize placeAddressLabel = _placeAddressLabel;
@synthesize placeNameLabel = _placeNameLabel;
@synthesize dataCenter = _dataCenter;
@synthesize checkinHereRequest = _checkinHereRequest;
@synthesize message = _message;
@synthesize tagsArray = _tagsArray;

@synthesize place = _place;

- (id)init {
  self = [super init];
  if (self) {
    _dataCenter = [[MoogleDataCenter alloc] init];
    _dataCenter.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.frame = CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT_WITH_NAV + 49.0);

  
  UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
  self.navigationItem.leftBarButtonItem = dismissButton;
  [dismissButton release];

  [self updatePlaceLabels];
  
  [self setupLoadingAndEmptyViews];
  
  [self.checkinMessage becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

// Subclasses may implement
- (void)setupLoadingAndEmptyViews {
  self.emptyView.hidden = YES;
  self.loadingView.hidden = YES;
}

- (void)updatePlaceLabels {
  // Load place info
  if (self.place) {
    self.placeNameLabel.text = self.place.placeName;
    self.placeAddressLabel.text = [self.place.placeStreet notNil] ? self.place.placeStreet : @"No Address Found";
  } else {
    self.placeNameLabel.text = @"Please Choose a Place to Check In";
    self.placeAddressLabel.text = @"Tap Here to Find Nearby Places";
  }
}

- (IBAction)cancel {
  [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)tagFriends {
}

- (IBAction)checkinHere {
  if (self.place) {
    [self postCheckin];
  } else {
    UIAlertView *placeAlert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"You Need to Choose a Place First" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [placeAlert show];
    [placeAlert autorelease];
  }
}

- (IBAction)choosePlace {
  NearbyPickerViewController *npvc = [[NearbyPickerViewController alloc] init];
  npvc.delegate = self;
  [self.navigationController pushViewController:npvc animated:YES];
  [npvc release];
}

- (void)nearbyPickedWithPlace:(Place *)place {
  self.place = place;
  [self updatePlaceLabels];
}

- (void)postCheckin {
  CGFloat lat = [APP_DELEGATE.locationManager latitude];
  CGFloat lng = [APP_DELEGATE.locationManager longitude];
  
  NSString *coordinates = [NSString stringWithFormat:@"{\"latitude\":\"%f\", \"longitude\":\"%f\"}", lat, lng];
  
  NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
  [postDict setObject:self.place.placeId forKey:@"place"];
  [postDict setObject:coordinates forKey:@"coordinates"];
  if (self.message) [postDict setObject:self.message forKey:@"message"];
  if (self.tagsArray) {
    NSString *tags = [self.tagsArray componentsJoinedByString:@","];
    [postDict setObject:tags forKey:@"tags"];
  }
  
  DLog(@"posting checkin to facebook with params: %@", postDict);
  self.checkinHereRequest = [RemoteRequest postFacebookCheckinRequestWithParams:postDict withDelegate:self.dataCenter];
  [[RemoteOperation sharedInstance] addRequestToQueue:self.checkinHereRequest];
}

- (void)postMoogleCheckin:(NSString *)checkinId {
  DLog(@"starting post share request to moogle");
  
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  [params setObject:checkinId forKey:@"checkin_id"];
  
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/checkins/checkin", MOOGLE_BASE_URL, API_VERSION];
  ASIHTTPRequest *moogleCheckinRequest = [RemoteRequest postRequestWithBaseURLString:baseURLString andParams:params isGzip:NO withDelegate:nil];
  [[RemoteOperation sharedInstance] addRequestToQueue:moogleCheckinRequest];
}

#pragma mark MoogleDataCenterDelegate
- (void)dataCenterDidFinish:(ASIHTTPRequest *)request {
  DLog(@"Successfully checked in with response: %@", [request responseString]);
  [self postMoogleCheckin:[self.dataCenter.rawResponse valueForKey:@"id"]];
  [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
  [self setCheckinMessage:nil];
  [self setPlaceAddressLabel:nil];
  [self setPlaceNameLabel:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)dealloc {
  if (_checkinHereRequest) {
    [_checkinHereRequest clearDelegatesAndCancel];
    [_checkinHereRequest release], _checkinHereRequest = nil;
  }
  
  RELEASE_SAFELY (_dataCenter);
  RELEASE_SAFELY (_message);
  RELEASE_SAFELY (_tagsArray);

  [super dealloc];
}


@end
