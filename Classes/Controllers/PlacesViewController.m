//
//  PlacesViewController.h.m
//  Moogle
//
//  Created by Peter Shih on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlacesViewController.h"
#import "PlaceViewController.h"
#import "LocationManager.h"
#import "PlaceCell.h"
#import "Place.h"

#import "PlacesDataCenter.h"

@interface PlacesViewController (Private)

- (void)setupButtons;
- (void)showPlaceForPlace:(Place *)place;
- (void)loadPlaces;

@end

@implementation PlacesViewController

@synthesize dataCenter = _dataCenter;
@synthesize nearbyRequest = _nearbyRequest;

- (id)init {
  self = [super init];
  if (self) {
    _dataCenter = [[PlacesDataCenter alloc] init];
    _dataCenter.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"Nearby Places";
  
  // Table
  CGRect tableFrame = CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT_WITH_NAV);
  [self setupTableViewWithFrame:tableFrame andStyle:UITableViewStylePlain andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  [self setupPullRefresh];
  [self setupSearchDisplayController];
  
  [self setupButtons];
}

- (void)setupButtons {
  
}

#pragma mark CardViewController
- (void)reloadCardController {
  [super reloadCardController];
  
  if (![APP_DELEGATE.locationManager hasAcquiredLocation]) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPlaces) name:kLocationAcquired object:nil];
  } else {
    [self loadPlaces];
  }
}

- (void)unloadCardController {
  [super unloadCardController];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kLocationAcquired object:nil];
}

- (void)loadPlaces {
  if ([APP_DELEGATE.locationManager hasAcquiredLocation] && [[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedIn"]) {
    [self getNearbyPlaces];
  }
}

- (void)getNearbyPlaces {
  CGFloat lat = [APP_DELEGATE.locationManager latitude];
  CGFloat lng = [APP_DELEGATE.locationManager longitude];
  NSInteger distance = [APP_DELEGATE.locationManager distance];
  
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  [params setObject:[NSString stringWithFormat:@"%f", lat] forKey:@"lat"];
  [params setObject:[NSString stringWithFormat:@"%f", lng] forKey:@"lng"];
  [params setObject:[NSString stringWithFormat:@"%d", distance] forKey:@"distance"];
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/places/nearby", MOOGLE_BASE_URL, API_VERSION];  
  self.nearbyRequest = [RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self.dataCenter];
  [[RemoteOperation sharedInstance] addRequestToQueue:self.nearbyRequest];

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
  [self.sections addObject:@"Places"];
  
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
  Place *place = nil;
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    place = [[self.searchItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  } else {
    place = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  }
  
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

#pragma mark UISearchDisplayDelegate
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
  // SUBCLASS MUST IMPLEMENT
  [self.searchItems removeAllObjects];
  
  for (NSArray *section in self.items) {
    [self.searchItems addObject:[NSMutableArray array]];
    for (Place *place in section) {
      NSComparisonResult result = [place.placeName compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
      if (result == NSOrderedSame) {
        [[self.searchItems lastObject] addObject:place];
      }
    }
  }
  
}

#pragma mark ImageCacheDelegate
- (void)loadImagesForOnScreenRows {
  NSArray *visibleIndexPaths = nil;
  if (self.searchDisplayController.active) {
    visibleIndexPaths = [self.searchDisplayController.searchResultsTableView indexPathsForVisibleRows];
  } else {
    visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
  }
  
  for (NSIndexPath *indexPath in visibleIndexPaths) {
//    NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//    NSURL *url = [NSURL URLWithString:[item valueForKey:@"picture"]];
    Place *place = nil;
    if (self.searchDisplayController.active) {
      place = [[self.searchItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    } else {
      place = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", place.placeId]];
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
  
  [super dealloc];
}


@end
