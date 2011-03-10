//
//  PlacesViewController.h.m
//  Moogle
//
//  Created by Peter Shih on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlacesViewController.h"

@interface PlacesViewController (Private)

- (void)loadPlaces;

@end

@implementation PlacesViewController

@synthesize nearbyRequest = _nearbyRequest;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"Nearby Places";
  
  // Table
  CGRect tableFrame = CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT_WITH_NAV);
  [self setupTableViewWithFrame:tableFrame andStyle:UITableViewStylePlain andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  [self setupPullRefresh];
  [self setupSearchDisplayController];
}

#pragma mark CardViewController
- (void)reloadCardController {
  [super reloadCardController];
  
  if (![APP_DELEGATE.locationManager hasAcquiredLocation]) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPlaces) name:kLocationAcquired object:nil];
  } else {
    [self loadPlaces];
  }
}

- (void)unloadCardController {
  [super unloadCardController];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kLocationAcquired object:nil];
}

- (void)loadPlaces {
  if ([APP_DELEGATE.locationManager hasAcquiredLocation] && [[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedIn"]) {
    [self getNearbyPlaces];
  }
}

- (void)getNearbyPlaces {
  CGFloat lat = [APP_DELEGATE.locationManager latitude];
  CGFloat lng = [APP_DELEGATE.locationManager longitude];
  NSInteger distance = [APP_DELEGATE.locationManager distance];
  
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  [params setObject:[NSString stringWithFormat:@"%f", lat] forKey:@"lat"];
  [params setObject:[NSString stringWithFormat:@"%f", lng] forKey:@"lng"];
  [params setObject:[NSString stringWithFormat:@"%d", distance] forKey:@"distance"];
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/places/nearby", MOOGLE_BASE_URL, API_VERSION];  
  self.nearbyRequest = [RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self.dataCenter];
  [[RemoteOperation sharedInstance] addRequestToQueue:self.nearbyRequest];

}

- (void)dealloc {
  if(_nearbyRequest) {
    [_nearbyRequest clearDelegatesAndCancel];
    [_nearbyRequest release], _nearbyRequest = nil;
  }
  
  [super dealloc];
}


@end
