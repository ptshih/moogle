//
//  TrendsViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TrendsViewController.h"
#import "Constants.h"

#import "LocationManager.h"

#import "TrendsDataCenter.h"

#import "ASIHTTPRequest.h"
#import "RemoteRequest.h"
#import "RemoteOperation.h"

#import "WhoViewController.h"
#import "PlaceViewController.h"

#import "PlaceCell.h"

@interface TrendsViewController (Private)

- (void)setupButtons;

- (void)showPlaceWithId:(NSNumber *)placeId andName:(NSString *)placeName;

@end

@implementation TrendsViewController

@synthesize dataCenter = _dataCenter;
@synthesize trendsRequest = _trendsRequest;

- (id)init {
  self = [super init];
  if (self) {
    _dataCenter = [[TrendsDataCenter alloc] init];
    _dataCenter.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"Moogle Trends";
  
  // Table
  [self setupTableViewWithFrame:self.view.frame andStyle:UITableViewStylePlain andSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [self setupPullRefresh];
  
  [self setupButtons];
}

- (void)setupButtons {  
  UIBarButtonItem *modeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_checkin.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(toggleMode)];
  UIBarButtonItem *whoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_checkin.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(toggleWho)];
  self.navigationItem.leftBarButtonItem = modeButton;
  self.navigationItem.rightBarButtonItem = whoButton;
  [modeButton release];
  [whoButton release];
}

#pragma mark CardViewController
- (void)reloadCardController {
  [super reloadCardController];
  
  [self getTrends];
}

- (void)getTrends {
  // Trends Mode
  CGFloat lat = [APP_DELEGATE.locationManager latitude];
  CGFloat lng = [APP_DELEGATE.locationManager longitude];
  
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  [params setObject:[NSString stringWithFormat:@"%f", lat] forKey:@"lat"];
  [params setObject:[NSString stringWithFormat:@"%f", lng] forKey:@"lng"];
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/checkins/trends", MOOGLE_BASE_URL, API_VERSION];
  self.trendsRequest = [RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self.dataCenter];
  
  [[RemoteOperation sharedInstance] addRequestToQueue:self.trendsRequest];
}

#pragma mark MoogleDataCenterDelegate
- (void)dataCenterDidFinish:(ASIHTTPRequest *)request {
  [self.sections removeAllObjects];
  [self.sections addObject:@"Checkins"];
  
  [self.items removeAllObjects];
  [self.items addObject:self.dataCenter.responseArray];
  [self.tableView reloadData];
  [self dataSourceDidLoad];
}

- (void)dataCenterDidFail:(ASIHTTPRequest *)request {
  [self dataSourceDidLoad];
}

- (void)showPlaceWithId:(NSNumber *)placeId andName:(NSString *)placeName {
  PlaceViewController *pvc = [[PlaceViewController alloc] init];
  pvc.placeId = placeId;
  pvc.placeName = placeName;
  pvc.shouldShowCheckinHere = NO;
  [self.navigationController pushViewController:pvc animated:YES];
  [pvc release];  
}

#pragma mark UITableView Stuff
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [PlaceCell rowHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PlaceCell *cell = nil;
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell_%d", [self class], indexPath.section];
  
  cell = (PlaceCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[PlaceCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
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
  
  [PlaceCell fillCell:cell withDictionary:item withImage:image];
  
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
  if(_trendsRequest) {
    [_trendsRequest clearDelegatesAndCancel];
    [_trendsRequest release], _trendsRequest = nil;
  }
  
  RELEASE_SAFELY(_dataCenter);
  [super dealloc];
}

@end
