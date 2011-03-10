//
//  DiscoverViewController.m
//  Moogle
//
//  Created by Peter Shih on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DiscoverViewController.h"
#import "PlacesDataCenter.h"
#import "PlaceViewController.h"
#import "LocationManager.h"
#import "PlaceCell.h"
#import "Place.h"

@interface DiscoverViewController (Private)

- (void)showPlaceForPlace:(Place *)place;

@end

@implementation DiscoverViewController

@synthesize dataCenter = _dataCenter;
@synthesize discoverRequest = _discoverRequest;

- (id)init {
  self = [super init];
  if (self) {
    _dataCenter = [[PlacesDataCenter alloc ]init];
    _dataCenter.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Table
  CGRect tableFrame = CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT_WITH_NAV);
  [self setupTableViewWithFrame:tableFrame andStyle:UITableViewStylePlain andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  [self setupPullRefresh];
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

#pragma mark Show Place
- (void)showPlaceForPlace:(Place *)place {
  PlaceViewController *pvc = [[PlaceViewController alloc] init];
  pvc.place = place;
  [self.navigationController pushViewController:pvc animated:YES];
  [pvc release];  
}

#pragma mark MoogleDataCenterDelegate
- (void)dataCenterDidFinish:(ASIHTTPRequest *)request {
  [self.sections removeAllObjects];
  [self.sections addObject:@"Shared Places"];
  
  [self.items removeAllObjects];
  [self.items addObject:self.dataCenter.placesArray];
  [self.tableView reloadData];
  [self dataSourceDidLoad];
}

- (void)dataCenterDidFail:(ASIHTTPRequest *)request {
  [self dataSourceDidLoad];
}

#pragma mark UITableView Stuff
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [PlaceCell rowHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  Place *place = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  [self showPlaceForPlace:place];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PlaceCell *cell = nil;
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell_%d", [self class], indexPath.section];
  
  cell = (PlaceCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if(cell == nil) { 
    cell = [[[PlaceCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier] autorelease];
  }
  
  //  NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  //  NSURL *url = [NSURL URLWithString:[item valueForKey:@"picture"]];
  Place *place = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", place.placeId]];
  UIImage *image = [self.imageCache getImageWithURL:url];
  if (!image) {
    if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
      [self.imageCache cacheImageWithURL:url forIndexPath:indexPath];
    }
    image = nil;
  }
  
  [PlaceCell fillCell:cell withPlace:place withImage:image];
  
  return cell;
}

#pragma mark ImageCacheDelegate
- (void)loadImagesForOnScreenRows {
  NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
  
  for (NSIndexPath *indexPath in visibleIndexPaths) {
    //    NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    //    NSURL *url = [NSURL URLWithString:[item valueForKey:@"picture"]];
    Place *place = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", place.placeId]];
    if (![self.imageCache getImageWithURL:url]) {
      [self.imageCache cacheImageWithURL:url forIndexPath:indexPath];
    }
  }
}

- (void)dealloc {
  if(_discoverRequest) {
    [_discoverRequest clearDelegatesAndCancel];
    [_discoverRequest release], _discoverRequest = nil;
  }
  
  RELEASE_SAFELY(_dataCenter);
  [super dealloc];
}

@end
