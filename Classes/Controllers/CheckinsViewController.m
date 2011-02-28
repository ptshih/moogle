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

#import "CheckinCell.h"

@interface CheckinsViewController (Private)

- (void)setupButtons;
- (void)setupFilterButtons;
- (void)animateShowFilter;
- (void)animateHideFilter;

- (void)showPlaceWithId:(NSNumber *)placeId andName:(NSString *)placeName;
@end

@implementation CheckinsViewController

@synthesize dataCenter = _dataCenter;
@synthesize checkinsRequest = _checkinsRequest;
@synthesize filterView = _filterView;

- (id)init {
  self = [super init];
  if (self) {
    _dataCenter = [[CheckinsDataCenter alloc ]init];
    _dataCenter.delegate = self;
    
    _filterView = [[UIView alloc] init];
    _isFiltering = NO;
    _who = [[NSString alloc] initWithString:@"friends"];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationController.navigationBar.tintColor = FB_COLOR_DARK_BLUE;
  self.title = @"Moogle Checkins";
  
  // Table
  [self setupTableViewWithFrame:self.view.frame andStyle:UITableViewStylePlain andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  [self setupPullRefresh];
  
  // Setup Filter View
  self.filterView.frame = CGRectMake(0, -44.0, 320.0, 44.0);
  self.filterView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"filter_gradient.png"]];
  
  [self.view addSubview:self.filterView];
  
  [self setupFilterButtons];
  [self setupButtons];
}

#pragma mark CardViewController
- (void)reloadCardController {
  [super reloadCardController];
  
  [self getCheckins];
}

- (void)setupButtons {    
  // Setup Filter button
  _filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleBordered target:self action:@selector(filter)];
  self.navigationItem.rightBarButtonItem = _filterButton;
}

#pragma mark Filters
- (void)setupFilterButtons {
  UIButton *categoryButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 8, 100, 29)];
  UIButton *distanceButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 8, 100, 29)];
  UIButton *whoButton = [[UIButton alloc] initWithFrame:CGRectMake(215, 8, 100, 29)];
  
  categoryButton.adjustsImageWhenHighlighted = NO;
  distanceButton.adjustsImageWhenHighlighted = NO;
  whoButton.adjustsImageWhenHighlighted = NO;
  
  [whoButton addTarget:self action:@selector(filterWho) forControlEvents:UIControlEventTouchUpInside];
  
  [categoryButton setBackgroundImage:[UIImage imageNamed:@"btn_filter.png"] forState:UIControlStateNormal];
  [categoryButton setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected.png"] forState:UIControlStateHighlighted];
  [distanceButton setBackgroundImage:[UIImage imageNamed:@"btn_filter.png"] forState:UIControlStateNormal];
  [distanceButton setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected.png"] forState:UIControlStateHighlighted];
  [whoButton setBackgroundImage:[UIImage imageNamed:@"btn_filter.png"] forState:UIControlStateNormal];
  [whoButton setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected.png"] forState:UIControlStateHighlighted];
  
  [categoryButton setTitle:@"Category" forState:UIControlStateNormal];
  [categoryButton setTitleColor:FILTER_COLOR_BLUE forState:UIControlStateNormal];
  categoryButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
  categoryButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
  
  [distanceButton setTitle:@"Distance" forState:UIControlStateNormal];
  [distanceButton setTitleColor:FILTER_COLOR_BLUE forState:UIControlStateNormal];
  distanceButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
  distanceButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
  
  [whoButton setTitle:@"Who" forState:UIControlStateNormal];
  [whoButton setTitleColor:FILTER_COLOR_BLUE forState:UIControlStateNormal];
  whoButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
  whoButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
  
  [self.filterView addSubview:categoryButton];
  [self.filterView addSubview:distanceButton];
  [self.filterView addSubview:whoButton];
  
  [categoryButton release];
  [distanceButton release];
  [whoButton release];
}

- (void)filter {
  if (_isFiltering) {
    // Hide filter drop-down
    [_filterButton setStyle:UIBarButtonItemStyleBordered];
    [_filterButton setTitle:@"Filter"];
    _isFiltering = NO;
    [self animateHideFilter];
  } else {
    // Show filter drop-down
    [_filterButton setStyle:UIBarButtonItemStyleDone];
    [_filterButton setTitle:@"Done"];
    _isFiltering = YES;
    [self animateShowFilter];
  }
}

#pragma mark Filter Button Actions
- (void)filterWho {
  _wvc = [[WhoViewController alloc] init];
  _wvc.delegate = self;
  [[APP_DELEGATE launcherViewController] presentModalViewController:_wvc animated:YES];
}

#pragma mark WhoFilterDelegate
- (void)whoPickedWithString:(NSString *)whoString {
  _who = [whoString retain];
  [_wvc release];
  [self getCheckins];
}


- (void)getCheckins {
  // Mode selection
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  [params setObject:_who forKey:@"who"];
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/checkins", MOOGLE_BASE_URL, API_VERSION];
  
  self.checkinsRequest = [RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self.dataCenter];
  [[RemoteOperation sharedInstance] addRequestToQueue:self.checkinsRequest];
}

- (void)animateShowFilter {
  [UIView beginAnimations:@"ShowFilter" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];  
	[UIView setAnimationDuration:0.3]; // Fade out is configurable in seconds (FLOAT)
  self.filterView.top = 0.0;
  self.tableView.frame = CGRectMake(0, 44.0, self.tableView.width, self.tableView.height - 44.0);
  //  self.tableView.contentInset = UIEdgeInsetsMake(44.0, 0.0, 0.0, 0.0);
	[UIView commitAnimations];
}

- (void)animateHideFilter {
  [UIView beginAnimations:@"HideFilter" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];  
	[UIView setAnimationDuration:0.3]; // Fade out is configurable in seconds (FLOAT)
  self.filterView.top = -44.0;
  self.tableView.frame = CGRectMake(0, 0, self.tableView.width, self.tableView.height + 44.0);
	[UIView commitAnimations];
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
  [self.items addObject:self.dataCenter.responseArray];
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
  
  RELEASE_SAFELY (_dataCenter);
  RELEASE_SAFELY (_filterButton);
  RELEASE_SAFELY (_filterView);
  [super dealloc];
}


@end