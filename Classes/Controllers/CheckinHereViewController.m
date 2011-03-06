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

@interface CheckinHereViewController (Private)

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
  
  UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
  self.navigationItem.leftBarButtonItem = dismissButton;
  [dismissButton release];
  
  // Load place info
  self.placeNameLabel.text = self.place.placeName;
  self.placeAddressLabel.text = self.place.placeStreet;
  
  [self.checkinMessage becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (IBAction)cancel {
  [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)tagFriends {
}

- (IBAction)checkinHere {
  [self postCheckin];
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
