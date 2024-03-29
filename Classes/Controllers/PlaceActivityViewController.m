//
//  PlaceActivityViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceActivityViewController.h"
#import "PlaceActivityCell.h"

@implementation PlaceActivityViewController

- (id)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self getPlaceActivity];
}
- (void)getPlaceActivity {
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/places/%@/activity", MOOGLE_BASE_URL, API_VERSION, self.place.placeId];
  
  _placeActivityRequest = [[RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self.dataCenter] retain];
  [[RemoteOperation sharedInstance] addRequestToQueue:_placeActivityRequest];
}

#pragma mark UITableView Stuff
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [PlaceActivityCell rowHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PlaceActivityCell *cell = nil;
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell_%d", [self class], indexPath.section];
  
  cell = (PlaceActivityCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[PlaceActivityCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
  }
  
  NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  
  [PlaceActivityCell fillCell:cell withDictionary:item withImage:nil];
  
  // Initial static render of cell
  if (tableView.dragging == NO && tableView.decelerating == NO) {
    [cell.smaImageView loadImage];
  }
  
  return cell;
}

#pragma mark MoogleDataCenterDelegate
- (void)dataCenterDidFinish:(ASIHTTPRequest *)request {
  // Update Table Cells
  [self.sections removeAllObjects];
  [self.items removeAllObjects];
  
  [self.sections addObject:@"Activity"];
  [self.items addObject:self.dataCenter.response];
  [self.tableView reloadData];
  
  [self dataSourceDidLoad];
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
