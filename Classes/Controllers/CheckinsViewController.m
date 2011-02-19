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

#import "CJSONDeserializer.h"

#import "NSDate+HumanInterval.h"

#import "WhoViewController.h"

@interface CheckinsViewController (Private)

- (void)setupButtons;
- (void)setupFilterButtons;
- (void)animateShowFilter;
- (void)animateHideFilter;
@end

@implementation CheckinsViewController

@synthesize checkinsRequest = _checkinsRequest;
@synthesize filterView = _filterView;

- (id)init {
  self = [super init];
  if (self) {
    _filterView = [[UIView alloc] init];
    _isFiltering = NO;
    _who = [[NSString alloc] initWithString:@"friends"];
  }
  return self;
}

- (void)loadView {
  [super loadView];
  
  self.navigationController.navigationBar.tintColor = FB_COLOR_DARK_BLUE;
  self.title = @"Moogle Checkins";
  
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
  
  self.checkinsRequest = [RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self];
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

#pragma mark ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
  // This is on the main thread
  NSInteger statusCode = [request responseStatusCode];
  if(statusCode > 200) {
    UIAlertView *networkErrorAlert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:FM_NETWORK_ERROR delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try Again", nil];
    [networkErrorAlert show];
    [networkErrorAlert autorelease];
  } else {
    [self.sections removeAllObjects];
    [self.sections addObject:@"Checkins"];
    
    [self.items removeAllObjects];
    [self.items addObject:[[CJSONDeserializer deserializer] deserializeAsArray:[request responseData] error:nil]];
    [self.tableView reloadData];
  }
  DLog(@"checkins request finished successfully");
}

- (void)requestFailed:(ASIHTTPRequest *)request {
  DLog(@"Request Failed with Error: %@", [request error]);
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
  cell.detailTextLabel.text = [[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"place_name"];
  
  //  NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[self.responseArray objectAtIndex:indexPath.row] objectForKey:@"checkin_timestamp"] intValue]];
  //  cell.detailTextLabel.text = [date humanIntervalSinceNow];
  
  return cell;
}

- (void)dealloc {
  if(_checkinsRequest) {
    [_checkinsRequest clearDelegatesAndCancel];
    [_checkinsRequest release], _checkinsRequest = nil;
  }
  
  RELEASE_SAFELY (_filterButton);
  RELEASE_SAFELY (_filterView);
  [super dealloc];
}


@end