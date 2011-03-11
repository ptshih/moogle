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

- (id)init {
  self = [super init];
  if (self) {
    _distance = [@"2" retain]; // default to 1 mile
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"Nearby Places";
  
  // Table
  CGRect tableFrame = CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT_WITH_NAV);
  [self setupTableViewWithFrame:tableFrame andStyle:UITableViewStylePlain andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  [self setupPullRefresh];
  [self setupSearchDisplayController];
  
  [self setupDistanceButton];
}

#pragma mark Distance Filter
- (void)toggleDistance {
  UIActionSheet *distanceActionSheet = [[UIActionSheet alloc] initWithTitle:@"How Far Away?" delegate:self cancelButtonTitle:@"Nevermind" destructiveButtonTitle:nil otherButtonTitles:@"1 miles", @"2 miles", @"5 miles", nil];
  [distanceActionSheet showInView:[APP_DELEGATE.launcherViewController view]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  NSLog(@"button: %d", buttonIndex);
  switch (buttonIndex) {
    case 0:
      _distance = [@"1" retain];
      break;
    case 1:
      _distance = [@"2" retain];
      break;
    case 2:
      _distance = [@"5" retain];
      break;
    case 3:
    default:
      break;
  }

  [_distanceButton setTitle:[NSString stringWithFormat:@"%@ miles", _distance]];
  [self reloadCardController];
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
//  NSInteger distance = [APP_DELEGATE.locationManager distance];
  
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  [params setObject:[NSString stringWithFormat:@"%f", lat] forKey:@"lat"];
  [params setObject:[NSString stringWithFormat:@"%f", lng] forKey:@"lng"];
//  [params setObject:[NSString stringWithFormat:@"%d", distance] forKey:@"distance"];
  if (![_distance isEqualToString:@""]) {
    [params setObject:_distance forKey:@"distance"];
  }
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
