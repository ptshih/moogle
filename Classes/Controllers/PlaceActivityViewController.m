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
  [self setupTableViewWithFrame:self.viewport andStyle:UITableViewStyleGrouped andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  [self reloadDataSource];
}

- (void)reloadDataSource {  
  [self getPlaceActivity];
}

- (void)getPlaceActivity {
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/places/%@/activity", MOOGLE_BASE_URL, API_VERSION, self.placeId];
  
  self.placeActivityRequest = [RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self.dataCenter];
  self.dataCenter.placeActivityRequest = self.placeActivityRequest;
  [[RemoteOperation sharedInstance] addRequestToQueue:self.placeActivityRequest];
}

#pragma mark UITableView Stuff
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell_%d", [self class], indexPath.section];
  
  cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
  }
  
  NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  
  cell.textLabel.text = [item objectForKey:@"name"];
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[item objectForKey:@"timestamp"] integerValue]];
  cell.detailTextLabel.text = [date humanIntervalSinceNow];
  
  return cell;
}

#pragma mark MoogleDataCenterDelegate
- (void)dataCenterDidFinish:(ASIHTTPRequest *)request {
  // Update Table Cells
  [self.sections removeAllObjects];
  [self.items removeAllObjects];
  
  [self.sections addObject:@"Activity"];
  [self.items addObject:self.dataCenter.activityArray];
  [self.tableView reloadData];
}

- (void)dataCenterDidFail:(ASIHTTPRequest *)request {
}

- (void)dealloc {
  if (_placeActivityRequest) {
    [_placeActivityRequest clearDelegatesAndCancel];
    [_placeActivityRequest release], _placeActivityRequest = nil;
  }
  
  [super dealloc];
}

@end
