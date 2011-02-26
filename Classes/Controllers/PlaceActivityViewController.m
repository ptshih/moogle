//
//  PlaceActivityViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceActivityViewController.h"


@implementation PlaceActivityViewController

@synthesize placeActivityRequest = _placeActivityRequest;

- (id)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Table
  //  CGRect tableFrame = self.view.frame;
  [self setupTableViewWithFrame:self.view.frame andStyle:UITableViewStyleGrouped andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  [self reloadDataSource];
}

- (void)reloadDataSource {  
  [self getPlaceActivity];
}

- (void)getPlaceActivity {
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/place/%@/activity", MOOGLE_BASE_URL, API_VERSION, self.placeId];
  
  self.placeActivityRequest = [RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self.dataCenter];
  self.dataCenter.placeActivityRequest = self.placeActivityRequest;
  [[RemoteOperation sharedInstance] addRequestToQueue:self.placeActivityRequest];
}

#pragma mark MoogleDataCenterDelegate
- (void)dataCenterDidFinish:(ASIHTTPRequest *)request {
  // Update Table Cells
  [self.sections removeAllObjects];
  [self.items removeAllObjects];
  
  [self.tableView reloadData];
}

- (void)dataCenterDidFail:(ASIHTTPRequest *)request {
  [self dataSourceDidLoad];
}

- (void)dealloc {
  if (_placeActivityRequest) {
    [_placeActivityRequest clearDelegatesAndCancel];
    [_placeActivityRequest release], _placeActivityRequest = nil;
  }
  
  [super dealloc];
}

@end
