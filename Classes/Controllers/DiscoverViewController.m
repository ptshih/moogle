//
//  DiscoverViewController.m
//  Moogle
//
//  Created by Peter Shih on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DiscoverViewController.h"

@interface DiscoverViewController (Private)

@end

@implementation DiscoverViewController

@synthesize discoverRequest = _discoverRequest;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Table
  CGRect tableFrame = CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT_WITH_NAV);
  [self setupTableViewWithFrame:tableFrame andStyle:UITableViewStylePlain andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  [self setupPullRefresh];
  [self setupSearchDisplayController];
  
  [self setupDistanceButton];
}

#pragma mark Distance Filter
// SUBCLASS can implement to override
- (void)toggleDistance {
  UIActionSheet *distanceActionSheet = [[UIActionSheet alloc] initWithTitle:@"How Far Away?" delegate:self cancelButtonTitle:@"Nevermind" destructiveButtonTitle:nil otherButtonTitles:@"2 miles", @"5 miles", @"25 miles", @"50 miles", @"Anywhere", nil];
  [distanceActionSheet showInView:[APP_DELEGATE.launcherViewController view]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  NSLog(@"button: %d", buttonIndex);
  switch (buttonIndex) {
    case 0:
      _distance = [@"2" retain];
      break;
    case 1:
      _distance = [@"5" retain];
      break;
    case 2:
      _distance = [@"25" retain];
      break;
    case 3:
      _distance = [@"50" retain];
      break;
    case 4:
      _distance = [@"" retain];
      break;
    case 5:
    default:
      break;
  }
  if ([_distance isEqualToString:@""]) {
    [_distanceButton setTitle:@"Anywhere"];
  } else {
    [_distanceButton setTitle:[NSString stringWithFormat:@"%@ miles", _distance]];
  }
  [self reloadCardController];
}

#pragma mark CardViewController
- (void)reloadCardController {
  [super reloadCardController];
  
  [self getDiscovers];
}

- (void)getDiscovers {
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  [params setObject:@"true" forKey:@"exclude"];
  [params setObject:@"true" forKey:@"random"];
  if (![_distance isEqualToString:@""]) {
    [params setObject:_distance forKey:@"distance"];
  }
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/places/popular", MOOGLE_BASE_URL, API_VERSION];
  self.discoverRequest = [RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self.dataCenter];
  
  [[RemoteOperation sharedInstance] addRequestToQueue:self.discoverRequest];
}

- (void)dealloc {
  if(_discoverRequest) {
    [_discoverRequest clearDelegatesAndCancel];
    [_discoverRequest release], _discoverRequest = nil;
  }
  
  [super dealloc];
}

@end
