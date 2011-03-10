//
//  PlaceFeedViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceFeedViewController.h"
#import "PlaceFeedCell.h"

@implementation PlaceFeedViewController

- (id)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self getPlaceFeed];
}

- (void)getPlaceFeed {
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/places/%@/feed", MOOGLE_BASE_URL, API_VERSION, self.place.placeId];
  
  _placeFeedRequest = [[RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self.dataCenter] retain];
  [[RemoteOperation sharedInstance] addRequestToQueue:_placeFeedRequest];
}

#pragma mark UITableView Stuff
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  return [PlaceFeedCell variableRowHeightWithDictionary:item];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PlaceFeedCell *cell = nil;
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell_%d", [self class], indexPath.section];
  
  cell = (PlaceFeedCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[PlaceFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
  }
  
  NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

  [PlaceFeedCell fillCell:cell withDictionary:item withImage:nil];
  
  // Initial static render of cell
  if (tableView.dragging == NO && tableView.decelerating == NO) {
    [cell.smaImageView loadImage];
  }
  
  return cell;
}

#pragma mark MoogleDataCenterDelegate
- (void)dataCenterDidFinish:(ASIHTTPRequest *)request {
  DLog(@"Reviews: %@", [request responseString]);
  // Update Table Cells
  [self.sections removeAllObjects];
  [self.items removeAllObjects];
  
  [self.sections addObject:@"Feed"];
  [self.items addObject:self.dataCenter.response];
  [self.tableView reloadData];
  
  [self dataSourceDidLoad];
}

- (void)dataCenterDidFail:(ASIHTTPRequest *)request {
  [self dataSourceDidLoad];
}

- (void)dealloc {
  if (_placeFeedRequest) {
    [_placeFeedRequest clearDelegatesAndCancel];
    [_placeFeedRequest release], _placeFeedRequest = nil;
  }
  
  [super dealloc];
}

@end
