//
//  PlaceViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceViewController.h"
#import "Constants.h"

#import "ASIHTTPRequest.h"
#import "RemoteRequest.h"
#import "RemoteOperation.h"

#import "LocationManager.h"

#import "MoogleDataCenter.h"

#import "CheckinHereViewController.h"

@interface PlaceViewController (Private)

- (void)getPlace;
- (void)showCheckinHereModal;

- (void)setupHeaderView;
- (void)setupCheckinHereButton;
- (void)updateHeaderView;

@end

@implementation PlaceViewController

@synthesize placeId = _placeId;
@synthesize placeRequest = _placeRequest;
@synthesize dataCenter = _dataCenter;

- (id)init {
  self = [super init];
  if (self) {
    _dataCenter = [[MoogleDataCenter alloc] init];
    _dataCenter.delegate = self;
  }
  return self;
}

- (void)loadView {
  [super loadView];
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self setupHeaderView];
  [self setupCheckinHereButton];
  [self getPlace];
}

- (void)setupHeaderView {
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 200)];
  UIImageView *placeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 0, 100, 100)];
  _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 27)];
  _friendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, 200, 27)];
  _likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 54, 200, 27)];
  
  headerView.backgroundColor = FB_COLOR_VERY_LIGHT_BLUE;
  placeImageView.backgroundColor = [UIColor clearColor];
  _totalLabel.backgroundColor = [UIColor clearColor];
  _friendsLabel.backgroundColor = [UIColor clearColor];
  _likesLabel.backgroundColor = [UIColor clearColor];
  
  placeImageView.contentMode = UIViewContentModeScaleAspectFit;
  placeImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", self.placeId]]]];
  
  _totalLabel.text = @"Total: Loading...";
  _friendsLabel.text = @"Friends: Loading...";
  _likesLabel.text = @"Likes: Loading...";

  
  [headerView addSubview:placeImageView];
  [headerView addSubview:_totalLabel];
  [headerView addSubview:_friendsLabel];
  [headerView addSubview:_likesLabel];
  
  [self.view addSubview:headerView];
  
  [headerView release];
}

- (void)updateHeaderView {
  //  {"name":"LinkedIn HQ","street":null,"city":null,"state":null,"country":null,"zip":null,"phone":null,"checkins_count":null,"distance":0.03135450056826266,"checkins_friend_count":0,"like_count":null,"attire":null,"website":null,"price":null}
  _totalLabel.text = [NSString stringWithFormat:@"Total: %@", [self.dataCenter.parsedResponse objectForKey:@"checkins_count"]];
  _friendsLabel.text = [NSString stringWithFormat:@"Friends: %@", [self.dataCenter.parsedResponse objectForKey:@"checkins_friend_count"]];
  _likesLabel.text = [NSString stringWithFormat:@"Likes: %@", [self.dataCenter.parsedResponse objectForKey:@"like_count"]];
}

- (void)setupCheckinHereButton {
  UIButton *checkinHereButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.height - 37, 320, 37)];
  [checkinHereButton setBackgroundColor:FB_COLOR_DARK_BLUE];
  [checkinHereButton addTarget:self action:@selector(showCheckinHereModal) forControlEvents:UIControlEventTouchUpInside];
  [checkinHereButton setTitle:@"Checkin Here" forState:UIControlStateNormal];
  [self.view addSubview:checkinHereButton];
  [checkinHereButton release];
}

- (void)showCheckinHereModal {
  CheckinHereViewController *chvc = [[CheckinHereViewController alloc] initWithNibName:@"CheckinHereViewController" bundle:nil];
  chvc.placeId = self.placeId;
  [APP_DELEGATE.launcherViewController presentModalViewController:chvc animated:YES];
  // NOTE: need to release here  
}

// Called when this card controller leaves active view
// Subclasses should override this method
- (void)unloadCardController {
  DLog(@"Called by class: %@", [self class]);
}

// Called when this card controller comes into active view
// Subclasses should override this method
- (void)reloadCardController {
  DLog(@"Called by class: %@", [self class]);
  
  [self getPlace];
}

- (void)getPlace {
  CGFloat lat = [APP_DELEGATE.locationManager latitude];
  CGFloat lng = [APP_DELEGATE.locationManager longitude];
  
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  [params setObject:[[NSNumber numberWithFloat:lat] stringValue] forKey:@"lat"];
  [params setObject:[[NSNumber numberWithFloat:lng] stringValue] forKey:@"lng"];
  
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/place/%@", MOOGLE_BASE_URL, API_VERSION, self.placeId];
  
  self.placeRequest = [RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self.dataCenter];
  [[RemoteOperation sharedInstance] addRequestToQueue:self.placeRequest];
}

#pragma mark MoogleDataCenterDelegate
- (void)dataCenterDidFinish:(ASIHTTPRequest *)request {
  DLog(@"Successfully got place with response: %@", [request responseString]);
  [self updateHeaderView];
}

- (void)dealloc {
  if (_placeRequest) {
    [_placeRequest clearDelegatesAndCancel];
    [_placeRequest release], _placeRequest = nil;
  }
  
  RELEASE_SAFELY (_dataCenter);
  
  RELEASE_SAFELY (_placeId);
  
  // UI
  RELEASE_SAFELY (_totalLabel);
  RELEASE_SAFELY (_friendsLabel);
  RELEASE_SAFELY (_likesLabel);
  [super dealloc];
}

@end
