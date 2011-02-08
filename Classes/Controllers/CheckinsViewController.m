//
//  CheckinsViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CheckinsViewController.h"
#import "Constants.h"

#import "ASIHTTPRequest.h"
#import "RemoteRequest.h"
#import "RemoteOperation.h"

#import "CJSONDeserializer.h"

#import "NSDate+HumanInterval.h"

@interface CheckinsViewController (Private)

- (void)setupButtons;

- (void)getCheckins;

@end

@implementation CheckinsViewController

@synthesize meTableView = _meTableView;

@synthesize checkinsRequest = _checkinsRequest;
@synthesize responseArray = _responseArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _responseArray = [[NSArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationController.navigationBar.tintColor = FB_COLOR_DARK_BLUE;
  self.title = @"Moogle";
  
  [self setupButtons];
  
  [self getCheckins];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)getCheckins {
  // Mode selection
  NSString *params = nil;
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/checkin/me/%@", MOOGLE_BASE_URL, API_VERSION, APP_DELEGATE.fbUserId];
  
  self.checkinsRequest = [RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self];
  [[RemoteOperation sharedInstance] addRequestToQueue:self.checkinsRequest];
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
    [self.meTableView reloadData];
  }
  DLog(@"me checkins request finished successfully");
}

- (void)requestFailed:(ASIHTTPRequest *)request {
  DLog(@"Request Failed with Error: %@", [request error]);
  UIAlertView *networkErrorAlert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:FM_NETWORK_ERROR delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try Again", nil];
  [networkErrorAlert show];
  [networkErrorAlert autorelease];
}

- (void)setupButtons {
  UIBarButtonItem *logoutButton = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)] autorelease];
  self.navigationItem.leftBarButtonItem = logoutButton;
}

- (void)logout {
  if (APP_DELEGATE.fbAccessToken) {
    UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [logoutAlert show];
    [logoutAlert autorelease];
  }
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
  RELEASE_SAFELY(_meTableView);
  RELEASE_SAFELY(_responseArray);
  [super dealloc];
}


@end
