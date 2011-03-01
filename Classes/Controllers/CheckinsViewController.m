//
//  CheckinsViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CheckinsViewController.h"
#import "Constants.h"

#import "ASIHTTPRequest.h"
#import "RemoteRequest.h"
#import "RemoteOperation.h"

#import "NSDate+HumanInterval.h"

#import "WhoViewController.h"
#import "PlaceViewController.h"
#import "CheckinsDataCenter.h"
#import "TrendsDataCenter.h"

#import "CheckinCell.h"

@interface CheckinsViewController (Private)

- (void)setupButtons;

- (void)toggleWho;
- (void)toggleMode;
- (void)swapMode;

- (void)showPlaceWithId:(NSNumber *)placeId andName:(NSString *)placeName;
@end

@implementation CheckinsViewController

@synthesize timelineDataCenter = _timelineDataCenter;
@synthesize trendsDataCenter = _trendsDataCenter;
@synthesize checkinsRequest = _checkinsRequest;
@synthesize trendsRequest = _trendsRequest;

- (id)init {
  self = [super init];
  if (self) {
    _timelineDataCenter = [[CheckinsDataCenter alloc ]init];
    _timelineDataCenter.delegate = self;
    _trendsDataCenter = [[TrendsDataCenter alloc] init];
    _trendsDataCenter.delegate = self;
    
    _who = [[NSString alloc] initWithString:@"friends"]; // Default timeline mode to friends
    _mode = CheckinsModeTimeline;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"Moogle Checkins";
  
  // Table
  [self setupTableViewWithFrame:self.view.frame andStyle:UITableViewStylePlain andSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [self setupPullRefresh];

  [self setupButtons];
}

#pragma mark CardViewController
- (void)reloadCardController {
  [super reloadCardController];
  
  [self getCheckins];
}

- (void)setupButtons {  
  UIBarButtonItem *modeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_checkin.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(toggleMode)];
  UIBarButtonItem *whoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_checkin.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(toggleWho)];
  self.navigationItem.leftBarButtonItem = modeButton;
  self.navigationItem.rightBarButtonItem = whoButton;
  [modeButton release];
  [whoButton release];
}

#pragma mark Button Actions
- (void)toggleWho {
  _wvc = [[WhoViewController alloc] init];
  _wvc.delegate = self;
  [[APP_DELEGATE launcherViewController] presentModalViewController:_wvc animated:YES];
}

- (void)toggleMode {
  if (_mode == CheckinsModeTimeline) {
    _mode = CheckinsModeTrending;
  } else {
    _mode = CheckinsModeTimeline;
  }
  
  // Swap the table view
  [self swapMode];
}

- (void)swapMode {
  [self.sections removeAllObjects];
  [self.items removeAllObjects];
  [self.tableView reloadData];
  [self updateState];
  [self getCheckins];  
}

#pragma mark WhoFilterDelegate
- (void)whoPickedWithString:(NSString *)whoString {
  _who = [whoString retain];
  [_wvc release];

  [self.sections removeAllObjects];
  [self.items removeAllObjects];
  [self.tableView reloadData];
  [self updateState];
  [self getCheckins];
}


- (void)getCheckins {
  NSMutableDictionary *params = nil;
  NSString *baseURLString = nil;
  
  // Mode selection
  if (_mode == CheckinsModeTimeline) {  
    // Timeline Mode
    params = [NSMutableDictionary dictionary];
    [params setObject:_who forKey:@"who"];
    baseURLString = [NSString stringWithFormat:@"%@/%@/checkins", MOOGLE_BASE_URL, API_VERSION];
    self.checkinsRequest = [RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self.timelineDataCenter];
    
    [[RemoteOperation sharedInstance] addRequestToQueue:self.checkinsRequest];
  } else {
    // Trending Mode
    params = [NSMutableDictionary dictionary];
    baseURLString = [NSString stringWithFormat:@"%@/%@/checkins/trends", MOOGLE_BASE_URL, API_VERSION];
    
    self.trendsRequest = [RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self.trendsDataCenter];
    
    [[RemoteOperation sharedInstance] addRequestToQueue:self.trendsRequest];
  }
}

- (void)showPlaceWithId:(NSNumber *)placeId andName:(NSString *)placeName {
  PlaceViewController *pvc = [[PlaceViewController alloc] init];
  pvc.placeId = placeId;
  pvc.placeName = placeName;
  pvc.shouldShowCheckinHere = NO;
  [self.navigationController pushViewController:pvc animated:YES];
  [pvc release];  
}

#pragma mark MoogleDataCenterDelegate
- (void)dataCenterDidFinish:(ASIHTTPRequest *)request {
  [self.sections removeAllObjects];
  [self.sections addObject:@"Checkins"];
  
  [self.items removeAllObjects];
  if (_mode == CheckinsModeTimeline) {
    [self.items addObject:self.timelineDataCenter.responseArray];
  } else {
    [self.items addObject:self.trendsDataCenter.responseArray];
  }
  [self.tableView reloadData];
  [self dataSourceDidLoad];
}

- (void)dataCenterDidFail:(ASIHTTPRequest *)request {
  [self dataSourceDidLoad];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  // Assume this is a network error
  if (buttonIndex != alertView.cancelButtonIndex) {
    [self getCheckins];
  }
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  [self showPlaceWithId:[[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"place_id"] andName:[[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"place_name"]];
}


#pragma mark UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  return [CheckinCell variableRowHeightWithDictionary:item];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CheckinCell *cell = nil;
  cell = (CheckinCell *)[tableView dequeueReusableCellWithIdentifier:@"CheckinCell"];
  if(cell == nil) { 
    cell = [[[CheckinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckinCell"] autorelease];
  }
  
  NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [item objectForKey:@"facebook_id"]]];
  
  UIImage *image = [self.imageCache getImageWithURL:url];
  if (!image) {
    if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
      [self.imageCache cacheImageWithURL:url forIndexPath:indexPath];
    }
    image = nil;
  }
  
  [CheckinCell fillCell:cell withDictionary:[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] withImage:image];
  
  return cell;
}

#pragma mark ImageCacheDelegate
- (void)loadImagesForOnScreenRows {
  NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
  
  for (NSIndexPath *indexPath in visibleIndexPaths) {
    NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [item objectForKey:@"facebook_id"]]];
    if (![self.imageCache getImageWithURL:url]) {
      [self.imageCache cacheImageWithURL:url forIndexPath:indexPath];
    }
  }
}

- (void)dealloc {
  if(_checkinsRequest) {
    [_checkinsRequest clearDelegatesAndCancel];
    [_checkinsRequest release], _checkinsRequest = nil;
  }
  
  if(_trendsRequest) {
    [_trendsRequest clearDelegatesAndCancel];
    [_trendsRequest release], _trendsRequest = nil;
  }
  
  RELEASE_SAFELY (_timelineDataCenter);
  RELEASE_SAFELY(_trendsDataCenter);
  [super dealloc];
}


@end