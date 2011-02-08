//
//  CheckinsViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CheckinsViewController.h"
#import "NearbyPlacesViewController.h"
#import "PlaceViewController.h"
#import "Constants.h"

#import "ASIHTTPRequest.h"
#import "RemoteRequest.h"
#import "RemoteOperation.h"

#import "CJSONDeserializer.h"

#import "NSDate+HumanInterval.h"

@interface CheckinsViewController (Private)

- (void)setupButtons;
- (void)animateShowFilter;
- (void)animateHideFilter;
- (void)getCheckins;

@end

@implementation CheckinsViewController

@synthesize nearbyPlacesViewController = _nearbyPlacesViewController;

@synthesize tableView = _tableView;
@synthesize filterView = _filterView;

@synthesize checkinsRequest = _checkinsRequest;
@synthesize responseArray = _responseArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _nearbyPlacesViewController = [[NearbyPlacesViewController alloc] initWithNibName:@"NearbyPlacesViewController" bundle:nil];
    _responseArray = [[NSArray alloc] init];
    _isFiltering = NO;
    _isShowingNearbyPlaces = NO;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationController.navigationBar.tintColor = FB_COLOR_DARK_BLUE;
  self.title = @"Moogle";
  
  self.filterView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"filter_gradient.png"]];
  
  [self setupButtons];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  if (APP_DELEGATE.isLoggedIn) {
    [self getCheckins];
  }
}

- (void)setupButtons {
//  UIBarButtonItem *logoutButton = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)] autorelease];
//  self.navigationItem.leftBarButtonItem = logoutButton;
  
  // Setup Checkin button
  UIBarButtonItem *checkinButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_checkin.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(checkin)] autorelease];
  self.navigationItem.leftBarButtonItem = checkinButton;
  
  // Setup Filter button
  UIBarButtonItem *filterButton = [[[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleBordered target:self action:@selector(filterCheckins)] autorelease];
  self.navigationItem.rightBarButtonItem = filterButton;
}

- (void)checkin {
  if (_isShowingNearbyPlaces) {
    _isShowingNearbyPlaces = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [self.view bringSubviewToFront:self.tableView];
    [UIView commitAnimations];
    [self.nearbyPlacesViewController.view removeFromSuperview];
  } else {
    _isShowingNearbyPlaces = YES;
    [self.view insertSubview:self.nearbyPlacesViewController.view atIndex:0];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [self.view bringSubviewToFront:self.nearbyPlacesViewController.view];
    [UIView commitAnimations];
  }
}

- (void)filterCheckins {
  if (_isFiltering) {
    // Hide filter drop-down
    _isFiltering = NO;
    [self animateHideFilter];
  } else {
    // Show filter drop-down
    _isFiltering = YES;
    [self animateShowFilter];
  }
}

- (void)getCheckins {
  // Mode selection
  NSString *params = nil;
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/checkin/me/%@", MOOGLE_BASE_URL, API_VERSION, APP_DELEGATE.fbUserId];
  
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

- (void)logout {
  if (APP_DELEGATE.fbAccessToken) {
    UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [logoutAlert show];
    [logoutAlert autorelease];
  }
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
    self.responseArray = [[CJSONDeserializer deserializer] deserializeAsArray:[request responseData] error:nil];
    [self.tableView reloadData];
  }
  DLog(@"checkins request finished successfully");
}

- (void)requestFailed:(ASIHTTPRequest *)request {
  DLog(@"Request Failed with Error: %@", [request error]);
  UIAlertView *networkErrorAlert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:FM_NETWORK_ERROR delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try Again", nil];
  [networkErrorAlert show];
  [networkErrorAlert autorelease];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex != alertView.cancelButtonIndex) {
    [self.navigationController popToRootViewControllerAnimated:NO];
    [APP_DELEGATE logoutFacebook];
  }
}

#pragma mark UITableViewDelegate

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.responseArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  cell = [tableView dequeueReusableCellWithIdentifier:@"CheckinCell"];
  if(cell == nil) { 
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CheckinCell"] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.numberOfLines = 100;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell_bg.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"table_cell_bg_selected.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:20]];
  }
  
  cell.textLabel.text = [[self.responseArray objectAtIndex:indexPath.row] objectForKey:@"place_name"];
  
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[self.responseArray objectAtIndex:indexPath.row] objectForKey:@"checkin_timestamp"] intValue]];
  cell.detailTextLabel.text = [date humanIntervalSinceNow];
  
  return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
  if(_checkinsRequest) {
    [_checkinsRequest clearDelegatesAndCancel];
    [_checkinsRequest release], _checkinsRequest = nil;
  }
  
  RELEASE_SAFELY(_nearbyPlacesViewController);
  RELEASE_SAFELY(_tableView);
  RELEASE_SAFELY(_filterView);
  RELEASE_SAFELY(_responseArray);
  [super dealloc];
}


@end
