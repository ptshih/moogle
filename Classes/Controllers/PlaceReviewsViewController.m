//
//  PlaceReviewsViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceReviewsViewController.h"


@implementation PlaceReviewsViewController

@synthesize placeReviewsRequest = _placeReviewsRequest;

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
  [self setupTableViewWithFrame:self.viewport andStyle:UITableViewStyleGrouped andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  [self reloadDataSource];
}

- (void)reloadDataSource {  
  [self getPlaceReviews];
}

- (void)getPlaceReviews {
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/places/%@/feed", MOOGLE_BASE_URL, API_VERSION, self.placeId];
  
  self.placeReviewsRequest = [RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self.dataCenter];
  self.dataCenter.placeReviewsRequest = self.placeReviewsRequest;
  [[RemoteOperation sharedInstance] addRequestToQueue:self.placeReviewsRequest];
}

#pragma mark MoogleDataCenterDelegate
- (void)dataCenterDidFinish:(ASIHTTPRequest *)request {
  // Update Table Cells
  [self.sections removeAllObjects];
  [self.items removeAllObjects];
  
  [self.tableView reloadData];
}

- (void)dataCenterDidFail:(ASIHTTPRequest *)request {
}

- (void)dealloc {
  if (_placeReviewsRequest) {
    [_placeReviewsRequest clearDelegatesAndCancel];
    [_placeReviewsRequest release], _placeReviewsRequest = nil;
  }
  
  [super dealloc];
}

@end
