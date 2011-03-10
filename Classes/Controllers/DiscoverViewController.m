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
