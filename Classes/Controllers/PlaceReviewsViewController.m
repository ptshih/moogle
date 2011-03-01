//
//  PlaceReviewsViewController.m
//  Moogle
//
//  Created by Peter Shih on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceReviewsViewController.h"
#import "PlaceReviewCell.h"

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
  
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/places/%@/reviews", MOOGLE_BASE_URL, API_VERSION, self.placeId];
  
  self.placeReviewsRequest = [RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self.dataCenter];
  self.dataCenter.placeReviewsRequest = self.placeReviewsRequest;
  [[RemoteOperation sharedInstance] addRequestToQueue:self.placeReviewsRequest];
}

#pragma mark UITableView Stuff
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  return [PlaceReviewCell variableRowHeightWithDictionary:item];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PlaceReviewCell *cell = nil;
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell_%d", [self class], indexPath.section];
  
  cell = (PlaceReviewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[PlaceReviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
  }
  
  NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  
  [PlaceReviewCell fillCell:cell withDictionary:item];
  
  return cell;
}

#pragma mark MoogleDataCenterDelegate
- (void)dataCenterDidFinish:(ASIHTTPRequest *)request {
  DLog(@"Reviews: %@", [request responseString]);
  // Update Table Cells
  [self.sections removeAllObjects];
  [self.items removeAllObjects];
  
  [self.sections addObject:@"Reviews"];
  [self.items addObject:self.dataCenter.reviewArray];
  [self.tableView reloadData];
  
  [self dataSourceDidLoad];
}

- (void)dataCenterDidFail:(ASIHTTPRequest *)request {
  [self dataSourceDidLoad];
}

- (void)dealloc {
  if (_placeReviewsRequest) {
    [_placeReviewsRequest clearDelegatesAndCancel];
    [_placeReviewsRequest release], _placeReviewsRequest = nil;
  }
  
  [super dealloc];
}

@end
