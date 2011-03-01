//
//  PlacesViewController.h.m
//  Moogle
//
//  Created by Peter Shih on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlacesViewController.h"
#import "Constants.h"
#import "PlaceCell.h"
#import "LocationManager.h"

#import "ASIHTTPRequest.h"
#import "RemoteRequest.h"
#import "RemoteOperation.h"

#import "PlaceViewController.h"
#import "PlacesDataCenter.h"

@interface PlacesViewController (Private)
- (void)showPlaceWithId:(NSNumber *)placeId andName:(NSString *)placeName;
@end

@implementation PlacesViewController

@synthesize dataCenter = _dataCenter;
@synthesize nearbyRequest = _nearbyRequest;

- (id)init {
  self = [super init];
  if (self) {
    _dataCenter = [[PlacesDataCenter alloc] init];
    _dataCenter.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNearbyPlaces) name:kLocationAcquired object:nil];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"Moogle Places";
  
  // Table
  [self setupTableViewWithFrame:self.view.frame andStyle:UITableViewStylePlain andSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [self setupPullRefresh];
  
//  self.navigationController.navigationBar.tintColor = FB_COLOR_DARK_BLUE;
//  self.title = @"Nearby Places";
  
//  [self getNearbyPlaces];
  
}

#pragma mark CardViewController
- (void)reloadCardController {
  [super reloadCardController];
  
  if ([APP_DELEGATE.locationManager hasAcquiredLocation] && [[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedIn"]) {
    [self getNearbyPlaces];
  } else {
    [self.sections removeAllObjects];
    [self.items removeAllObjects];
    [self.tableView reloadData];
    [self updateState];
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

- (void)showPlaceWithId:(NSNumber *)placeId andName:(NSString *)placeName {
  PlaceViewController *pvc = [[PlaceViewController alloc] init];
  pvc.placeId = placeId;
  pvc.placeName = placeName;
  pvc.shouldShowCheckinHere = YES;
  [self.navigationController pushViewController:pvc animated:YES];
  [pvc release];  
}

#pragma mark MoogleDataCenterDelegate
- (void)dataCenterDidFinish:(ASIHTTPRequest *)request {
  [self.sections removeAllObjects];
  [self.sections addObject:@"Nearby Places"];
  
  [self.items removeAllObjects];
  [self.items addObject:self.dataCenter.responseArray];
  [self.tableView reloadData];
  [self dataSourceDidLoad];
}

- (void)dataCenterDidFail:(ASIHTTPRequest *)request {
  [self dataSourceDidLoad];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  [self showPlaceWithId:[[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"place_id"] andName:[[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"]];
}

#pragma mark UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [PlaceCell rowHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PlaceCell *cell = nil;
  cell = (PlaceCell *)[tableView dequeueReusableCellWithIdentifier:@"CheckinCell"];
  if(cell == nil) { 
    cell = [[[PlaceCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CheckinCell"] autorelease];
  }
  
  NSDictionary *place = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [place objectForKey:@"place_id"]]];
  
  UIImage *placeImage = [self.imageCache getImageWithURL:url];
  if (!placeImage) {
    if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
      [self.imageCache cacheImageWithURL:url forIndexPath:indexPath];
    }
    placeImage = nil;
  }
  
  [PlaceCell fillCell:cell withDictionary:[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] withImage:placeImage];
  
  return cell;
}

#pragma mark ImageCacheDelegate
- (void)loadImagesForOnScreenRows {
  NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
  
  for (NSIndexPath *indexPath in visibleIndexPaths) {
    NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [item objectForKey:@"place_id"]]];
    if (![self.imageCache getImageWithURL:url]) {
      [self.imageCache cacheImageWithURL:url forIndexPath:indexPath];
    }
  }
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