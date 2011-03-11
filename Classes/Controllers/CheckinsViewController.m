//
//  CheckinsViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CheckinsViewController.h"

#import "WhoViewController.h"
#import "PlaceViewController.h"
#import "CheckinsDataCenter.h"

#import "CheckinCell.h"
#import "Checkin.h"
#import "Place.h"

@interface CheckinsViewController (Private)

- (void)setupButtons;

- (void)toggleWho;
- (void)toggleDistance;

- (void)showPlaceForPlace:(Place *)place;

@end

@implementation CheckinsViewController

@synthesize dataCenter = _dataCenter;
@synthesize checkinsRequest = _checkinsRequest;


- (id)init {
  self = [super init];
  if (self) {
    _dataCenter = [[CheckinsDataCenter alloc ]init];
    _dataCenter.delegate = self;
    
    _who = [[NSString alloc] initWithString:@"friends"]; // Default timeline mode to friends
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Table
  CGRect tableFrame = CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT_WITH_NAV);
  [self setupTableViewWithFrame:tableFrame andStyle:UITableViewStylePlain andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  [self setupPullRefresh];

  [self setupButtons];
}

#pragma mark CardViewController
- (void)reloadCardController {
  [super reloadCardController];
  
  [self getCheckins];
}

- (void)setupButtons {
  UIBarButtonItem *whoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn-who.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(toggleWho)];

  self.navigationItem.rightBarButtonItem = whoButton;
  [whoButton release];
}

#pragma mark Button Actions
- (void)toggleWho {
  WhoViewController *wvc = [[WhoViewController alloc] init];
  wvc.delegate = self;
  UINavigationController *wvcNav = [[UINavigationController alloc] initWithRootViewController:wvc];
  [[APP_DELEGATE launcherViewController] presentModalViewController:wvcNav animated:YES];
  [wvc release];
  [wvcNav release];
}

#pragma mark FriendPickerDelegate
- (void)friendPickedWithFriendIds:(NSString *)friendIds {
  _who = [friendIds copy];

  [self.sections removeAllObjects];
  [self.items removeAllObjects];
  [self.tableView reloadData];
  [self updateState];
  [self getCheckins];
}


- (void)getCheckins {
  // Timeline Mode
  CGFloat distance = 1.0;
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  [params setObject:_who forKey:@"who"];
//  [params setObject:@"1291192051" forKey:@"until"];
//  [params setObject:@"2" forKey:@"count"];
  [params setObject:[NSString stringWithFormat:@"%.2f", distance] forKey:@"distance"];
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/checkins", MOOGLE_BASE_URL, API_VERSION];
  self.checkinsRequest = [RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self.dataCenter];
  
  [[RemoteOperation sharedInstance] addRequestToQueue:self.checkinsRequest];
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
  [self.sections addObject:@"Checkins"];
  
  [self.items removeAllObjects];
  [self.items addObject:self.dataCenter.checkinsArray];
  [self.tableView reloadData];
  [self dataSourceDidLoad];
}

- (void)dataCenterDidFail:(ASIHTTPRequest *)request {
  [self dataSourceDidLoad];
}

#pragma mark UITableView Stuff
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  Checkin *checkin = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  return [CheckinCell variableRowHeightWithCheckin:checkin];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  Place *place = [[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] place];
  [self showPlaceForPlace:place];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CheckinCell *cell = nil;
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell_%d", [self class], indexPath.section];
  
  cell = (CheckinCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if(cell == nil) { 
    cell = [[[CheckinCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier] autorelease];
  }

  Checkin *checkin = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  
  [CheckinCell fillCell:cell withCheckin:checkin withImage:nil];
  
  // Initial static render of cell
  if (tableView.dragging == NO && tableView.decelerating == NO) {
    [cell.smaImageView loadImage];
  }
  
  return cell;
}

- (void)dealloc {
  if(_checkinsRequest) {
    [_checkinsRequest clearDelegatesAndCancel];
    [_checkinsRequest release], _checkinsRequest = nil;
  }
  
  RELEASE_SAFELY(_dataCenter);
  [super dealloc];
}


@end