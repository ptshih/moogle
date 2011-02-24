//
//  NearbyViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NearbyViewController.h"
#import "Constants.h"
#import "LocationManager.h"

#import "ASIHTTPRequest.h"
#import "RemoteRequest.h"
#import "RemoteOperation.h"

#import "MoogleDataCenter.h"

@implementation NearbyViewController

@synthesize dataCenter = _dataCenter;
@synthesize nearbyRequest = _nearbyRequest;

- (id)init {
  self = [super init];
  if (self) {
    _dataCenter = [[MoogleDataCenter alloc] init];
    _dataCenter.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNearbyPlaces) name:kLocationAcquired object:nil];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationController.navigationBar.tintColor = FB_COLOR_DARK_BLUE;
  self.title = @"Moogle Places";
  
//  self.navigationController.navigationBar.tintColor = FB_COLOR_DARK_BLUE;
//  self.title = @"Nearby Places";
  
//  [self getNearbyPlaces];
  
}

#pragma mark CardViewController
- (void)reloadCardController {
  [super reloadCardController];
  
  [APP_DELEGATE.locationManager startStandardUpdates];
  
  if ([APP_DELEGATE.locationManager hasAcquiredLocation]) {
    [self getNearbyPlaces];
  }
}

- (void)getNearbyPlaces {
  CGFloat lat = [APP_DELEGATE.locationManager latitude];
  CGFloat lng = [APP_DELEGATE.locationManager longitude];
  NSInteger distance = [APP_DELEGATE.locationManager distance];
  NSString *query = @"";
  
  DLog(@"requesting nearby facebook places at lat: %f, lng: %f, distance: %d", lat, lng, distance);
  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f", lat], @"lat", [NSString stringWithFormat:@"%f", lng], @"lng", [NSString stringWithFormat:@"%d", distance], @"distance", query, @"query", nil];
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/checkins/nearby", MOOGLE_BASE_URL, API_VERSION];
  self.nearbyRequest = [RemoteRequest postRequestWithBaseURLString:baseURLString andParams:params isGzip:NO withDelegate:self.dataCenter];
  [[RemoteOperation sharedInstance] addRequestToQueue:self.nearbyRequest];
}

#pragma mark MoogleDataCenterDelegate
- (void)dataCenterDidFinish:(ASIHTTPRequest *)request {
  [self.sections removeAllObjects];
  [self.sections addObject:@"Nearby Places"];
  
  [self.items removeAllObjects];
  [self.items addObject:self.dataCenter.parsedResponse];
  [self.tableView reloadData];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  [self showPlaceWithId:[[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"place_id"]];
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  cell = [tableView dequeueReusableCellWithIdentifier:@"CheckinCell"];
  if(cell == nil) { 
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CheckinCell"] autorelease];
    cell.textLabel.numberOfLines = 100;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell_bg.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"table_cell_bg_selected.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:20]];
  }
  
  cell.textLabel.text = [[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
  cell.detailTextLabel.text = [[[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"distance"] stringValue];
  
  return cell;
}

- (void)dealloc {
  if(_nearbyRequest) {
    [_nearbyRequest clearDelegatesAndCancel];
    [_nearbyRequest release], _nearbyRequest = nil;
  }
  
  RELEASE_SAFELY (_dataCenter);
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kLocationAcquired object:nil];
  
  [super dealloc];
}


@end
