//
//  CheckinsViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MeViewController.h"
#import "Constants.h"

#import "ASIHTTPRequest.h"
#import "RemoteRequest.h"
#import "RemoteOperation.h"

#import "CJSONDeserializer.h"

#import "NSDate+HumanInterval.h"

@interface MeViewController (Private)

- (void)setupButtons;

@end

@implementation MeViewController

@synthesize checkinsRequest = _checkinsRequest;

- (id)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)loadView {
  [super loadView];
  
  self.navigationController.navigationBar.tintColor = FB_COLOR_DARK_BLUE;
  self.title = @"Moogle Me";
  
  [self setupButtons];
}

#pragma mark CardViewController
- (void)reloadCardController {
  [super reloadCardController];
  
  [self getCheckins];
}

- (void)setupButtons {
//  UIBarButtonItem *logoutButton = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)] autorelease];
//  self.navigationItem.leftBarButtonItem = logoutButton;
  
  // Setup Checkin button
  UIBarButtonItem *checkinButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_checkin.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(checkin)] autorelease];
  self.navigationItem.leftBarButtonItem = checkinButton;
}

- (void)checkin {
  _logoutAlert = [[UIAlertView alloc] initWithTitle:@"Logout of Moogle?" message:MOOGLE_LOGOUT_ALERT delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
  [_logoutAlert show];
  [_logoutAlert autorelease];
}

- (void)getCheckins {
  // Mode selection
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  [params setObject:@"me" forKey:@"people"];
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/checkins", MOOGLE_BASE_URL, API_VERSION];
  
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
  if ([alertView isEqual:_logoutAlert]) {
    if (buttonIndex != alertView.cancelButtonIndex) {
      [self.navigationController popToRootViewControllerAnimated:NO];
      [APP_DELEGATE logoutFacebook];
    }
  } else {
    // Assume this is a network error
    if (buttonIndex != alertView.cancelButtonIndex) {
      [self getCheckins];
    }
  }
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  [self showPlaceWithId:[[self.items objectAtIndex:indexPath.row] objectForKey:@"place_id"]];
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
  
  [super dealloc];
}


@end
