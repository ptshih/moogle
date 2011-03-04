//
//  NearbyModalViewController.m
//  Moogle
//
//  Created by Peter Shih on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NearbyModalViewController.h"
#import "PlaceCell.h"
#import "LocationManager.h"

#import "PlaceViewController.h"
#import "PlacesDataCenter.h"

@interface NearbyModalViewController (Private)

- (void)setupNavigationBar;
- (void)setupButtons;
- (void)showPlaceWithId:(NSString *)placeId andName:(NSString *)placeName;

@end

@implementation NearbyModalViewController

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
  
  self.view.frame = CGRectMake(0, 0, 320, 460);
  self.title = @"Nearby Places";
  
  [self setupNavigationBar];
  
  // Table
  CGRect tableFrame = CGRectMake(0, 44, CARD_WIDTH, 416);
  [self setupTableViewWithFrame:tableFrame andStyle:UITableViewStylePlain andSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [self setupPullRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self reloadCardController];
}

- (void)setupNavigationBar {
  UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
  UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:self.title];
  UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
  navigationItem.leftBarButtonItem = dismissButton;
  [dismissButton release];
  [navigationBar setItems:[NSArray arrayWithObject:navigationItem]];
  
  navigationBar.tintColor = MOOGLE_BLUE_COLOR;
  [self.view addSubview:navigationBar];
  
  [navigationItem release];
  [navigationBar release];
}

- (void)setupButtons {
}

- (void)dismiss {
  [self dismissModalViewControllerAnimated:YES];
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

#pragma mark CardViewController
- (void)reloadCardController {
  [super reloadCardController];
  
  // NOTE: There is a bug here because of the frame difference between a card and a modal
  
  [self getNearbyPlaces];
}

#pragma mark Show Place
- (void)showPlaceWithId:(NSString *)placeId andName:(NSString *)placeName {
  PlaceViewController *pvc = [[PlaceViewController alloc] init];
  pvc.placeId = placeId;
  pvc.placeName = placeName;
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


#pragma mark UITableView Stuff
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [PlaceCell rowHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  [self showPlaceWithId:[[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"place_id"] andName:[[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"place_name"]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PlaceCell *cell = nil;
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell_%d", [self class], indexPath.section];
  
  cell = (PlaceCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if(cell == nil) { 
    cell = [[[PlaceCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier] autorelease];
  }
  
  NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [item valueForKey:@"place_id"]]];
  UIImage *image = [self.imageCache getImageWithURL:url];
  if (!image) {
    if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
      [self.imageCache cacheImageWithURL:url forIndexPath:indexPath];
    }
    image = nil;
  }
  
  [PlaceCell fillCell:cell withDictionary:[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] withImage:image];
  
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
