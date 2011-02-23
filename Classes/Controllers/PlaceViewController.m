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
- (void)setupCheckinHereButton;
- (void)showCheckinHereModal;

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
  
  [self setupCheckinHereButton];
  [self getPlace];
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
}

- (void)dealloc {
  if (_placeRequest) {
    [_placeRequest clearDelegatesAndCancel];
    [_placeRequest release], _placeRequest = nil;
  }
  
  RELEASE_SAFELY (_dataCenter);
  
  RELEASE_SAFELY (_placeId);
  [super dealloc];
}


@end
