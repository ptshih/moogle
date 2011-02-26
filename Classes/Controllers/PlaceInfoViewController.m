//
//  PlaceInfoViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceInfoViewController.h"
#import "PlaceHeaderCell.h"

@implementation PlaceInfoViewController

@synthesize placeInfoRequest = _placeInfoRequest;

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
  [self getPlaceInfo];
}

- (void)getPlaceInfo {
  CGFloat lat = [APP_DELEGATE.locationManager latitude];
  CGFloat lng = [APP_DELEGATE.locationManager longitude];
  
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  [params setObject:[[NSNumber numberWithFloat:lat] stringValue] forKey:@"lat"];
  [params setObject:[[NSNumber numberWithFloat:lng] stringValue] forKey:@"lng"];
  
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/places/%@", MOOGLE_BASE_URL, API_VERSION, self.placeId];
  
  self.placeInfoRequest = [RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self.dataCenter];
  self.dataCenter.placeInfoRequest = self.placeInfoRequest;
  [[RemoteOperation sharedInstance] addRequestToQueue:self.placeInfoRequest];
}

#pragma mark UITableViewDelegate
#pragma mark UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  // NOTE: temporary hard coded heights
  if (indexPath.section == 0) {
    return 88.0;
  } else {
    return 44.0;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell_%d", [self class], indexPath.section];
  
  // NOTE: temporary hard coded sections
  // Should eventually change this to be a cellTypeForIndexPath call
  if (indexPath.section == 0) {
    cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
      cell = [[[PlaceHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
    }
    [PlaceHeaderCell fillCell:cell withDictionary:[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
  } else {
    cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
    }
    NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = [[item allKeys] objectAtIndex:0];
    cell.detailTextLabel.text = [[item allValues] objectAtIndex:0];
  }
  return cell;
}

#pragma mark MoogleDataCenterDelegate
- (void)dataCenterDidFinish:(ASIHTTPRequest *)request {
  // Update Table Cells
  [self.sections removeAllObjects];
  [self.items removeAllObjects];
  
  // Header
  [self.sections addObject:@"HeaderCell"];
  [self.items addObject:self.dataCenter.headersArray];
  
  // Details
  [self.sections addObject:@"DetailsCell"];
  [self.items addObject:self.dataCenter.detailsArray];
  
  [self.tableView reloadData];
}

- (void)dataCenterDidFail:(ASIHTTPRequest *)request {
  [self dataSourceDidLoad];
}

- (void)dealloc {
  if (_placeInfoRequest) {
    [_placeInfoRequest clearDelegatesAndCancel];
    [_placeInfoRequest release], _placeInfoRequest = nil;
  }

  [super dealloc];
}

@end
