//
//  PlaceViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceViewController.h"
#import "Constants.h"

#import "ASIHTTPRequest.h"
#import "RemoteRequest.h"
#import "RemoteOperation.h"

#import "LocationManager.h"

#import "MoogleDataCenter.h"

#import "CheckinHereViewController.h"

#import "CJSONDeserializer.h"

#import "PlaceHeaderCell.h"

@interface PlaceViewController (Private)

- (void)getPlace;
- (void)showCheckinHereModal;

- (void)setupHeaderView;
- (void)setupCheckinHereButton;
- (void)updateHeaderView;

@end

@implementation PlaceViewController

@synthesize placeId = _placeId;
@synthesize placeName = _placeName;
@synthesize shouldShowCheckinHere = _shouldShowCheckinHere;
@synthesize placeRequest = _placeRequest;
@synthesize dataCenter = _dataCenter;

- (id)init {
  self = [super init];
  if (self) {
    _dataCenter = [[MoogleDataCenter alloc] init];
    _dataCenter.delegate = self;
    
    _shouldShowCheckinHere = NO;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  self.title = self.placeName;
  
  CGRect tableFrame = CGRectZero;
  
  if (_shouldShowCheckinHere) {
    [self setupCheckinHereButton];
    tableFrame = CGRectMake(0, 0, self.view.width, self.view.height - _checkinHereButton.height);
  } else {
    tableFrame = CGRectMake(0, 0, self.view.width, self.view.height);
  }
  
  // Table
  [self setupTableViewWithFrame:tableFrame andStyle:UITableViewStyleGrouped andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  
  [self getPlace];
}

- (void)setupCheckinHereButton {
  _checkinHereButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.height - 37, 320, 37)];
  [_checkinHereButton setBackgroundColor:FB_COLOR_DARK_BLUE];
  [_checkinHereButton addTarget:self action:@selector(showCheckinHereModal) forControlEvents:UIControlEventTouchUpInside];
  [_checkinHereButton setTitle:@"Checkin Here" forState:UIControlStateNormal];
  [self.view addSubview:_checkinHereButton];
}

- (void)showCheckinHereModal {
  _checkinHereViewController = [[CheckinHereViewController alloc] initWithNibName:@"CheckinHereViewController" bundle:nil];
  _checkinHereViewController.placeId = self.placeId;
  [APP_DELEGATE.launcherViewController presentModalViewController:_checkinHereViewController animated:YES];
}

// Called when this card controller leaves active view
// Subclasses should override this method
- (void)unloadCardController {
  DLog(@"Called by class: %@", [self class]);
}

// Called when this card controller comes into active view
// Subclasses should override this method
- (void)reloadCardController {
  DLog(@"Called by class: %@", [self class]);
  
  [self getPlace];
}

- (void)getPlace {
  CGFloat lat = [APP_DELEGATE.locationManager latitude];
  CGFloat lng = [APP_DELEGATE.locationManager longitude];
  
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  [params setObject:[[NSNumber numberWithFloat:lat] stringValue] forKey:@"lat"];
  [params setObject:[[NSNumber numberWithFloat:lng] stringValue] forKey:@"lng"];
  
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/place/%@", MOOGLE_BASE_URL, API_VERSION, self.placeId];
  
  self.placeRequest = [RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self.dataCenter];
  [[RemoteOperation sharedInstance] addRequestToQueue:self.placeRequest];
}

#pragma mark UITableViewDelegate
#pragma mark UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  // NOTE: temporary hard coded heights
  if (indexPath.section == 0) {
    return 88.0;
  } else {
    return 44.0;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell_%d", [self class], indexPath.section];
  
  // NOTE: temporary hard coded sections
  // Should eventually change this to be a cellTypeForIndexPath call
  if (indexPath.section == 0) {
    cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
      cell = [[[PlaceHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
      [PlaceHeaderCell fillCell:cell withDictionary:[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    }
  } else {
    cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
    }
    NSString *distance = [NSString stringWithFormat:@"%.2fmi", [[[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"distance"] floatValue]];
    cell.textLabel.text = @"Distance";
    cell.detailTextLabel.text = distance;
  }
  return cell;
}

#pragma mark MoogleDataCenterDelegate
- (void)dataCenterDidFinish:(ASIHTTPRequest *)request {
  NSDictionary *responseDict = [[CJSONDeserializer deserializer] deserialize:[request responseData] error:nil];
  
  DLog(@"Successfully got place with response: %@", responseDict);

  // Update Table Cells
  [self.sections removeAllObjects];
  [self.items removeAllObjects];
  
  // Header
  [self.sections addObject:@"HeaderCell"];
  [self.items addObject:[NSArray arrayWithObject:responseDict]];
  
  // Details
  [self.sections addObject:@"DetailsCell"];
  NSArray *items = [NSArray arrayWithObject:[NSDictionary dictionaryWithObject:[responseDict objectForKey:@"distance"] forKey:@"distance"]];
  
  [self.items addObject:items];
  [self.tableView reloadData];
}

- (void)dealloc {
  if (_placeRequest) {
    [_placeRequest clearDelegatesAndCancel];
    [_placeRequest release], _placeRequest = nil;
  }
  
  RELEASE_SAFELY(_checkinHereViewController);
  RELEASE_SAFELY (_dataCenter);
  RELEASE_SAFELY(_placeName);
  RELEASE_SAFELY (_placeId);
  
  // UI
  RELEASE_SAFELY(_checkinHereButton);
  [super dealloc];
}

@end
