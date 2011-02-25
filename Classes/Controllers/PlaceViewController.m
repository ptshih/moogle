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

@interface PlaceViewController (Private)

- (void)getPlace;
- (void)showCheckinHereModal;

- (void)setupHeaderView;
- (void)setupCheckinHereButton;
- (void)updateHeaderView;

@end

@implementation PlaceViewController

@synthesize placeId = _placeId;
@synthesize shouldShowCheckinHere = _shouldShowCheckinHere;
@synthesize placeRequest = _placeRequest;
@synthesize dataCenter = _dataCenter;
@synthesize tableView = _tableView;
@synthesize sections = _sections;
@synthesize items = _items;

- (id)init {
  self = [super init];
  if (self) {
    _dataCenter = [[MoogleDataCenter alloc] init];
    _dataCenter.delegate = self;
    
    _shouldShowCheckinHere = NO;
    
    _sections = [[NSMutableArray alloc] initWithCapacity:1];
    _items = [[NSMutableArray alloc] initWithCapacity:1];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  CGRect tableFrame = CGRectZero;
  
  if (_shouldShowCheckinHere) {
    [self setupCheckinHereButton];
    tableFrame = CGRectMake(0, 0, self.view.width, self.view.height - _checkinHereButton.height);
  } else {
    tableFrame = CGRectMake(0, 0, self.view.width, self.view.height);
  }
  
  // Table
  _tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.view addSubview:self.tableView];
  
  [self getPlace];
}

- (void)setupHeaderView {
  _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
  UIImageView *placeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(210, 0, 100, 100)];
  _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 27)];
  _friendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 27, 200, 27)];
  _likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 54, 200, 27)];
  
  _headerView.backgroundColor = FB_COLOR_VERY_LIGHT_BLUE;
  placeImageView.backgroundColor = [UIColor clearColor];
  _totalLabel.backgroundColor = [UIColor clearColor];
  _friendsLabel.backgroundColor = [UIColor clearColor];
  _likesLabel.backgroundColor = [UIColor clearColor];
  
  placeImageView.contentMode = UIViewContentModeScaleAspectFit;
  placeImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", self.placeId]]]];
  
  _totalLabel.text = @"Total: Loading...";
  _friendsLabel.text = @"Friends: Loading...";
  _likesLabel.text = @"Likes: Loading...";
  
  [placeImageView release];
}

- (void)updateHeaderView {
  //  {"name":"LinkedIn HQ","street":null,"city":null,"state":null,"country":null,"zip":null,"phone":null,"checkins_count":null,"distance":0.03135450056826266,"checkins_friend_count":0,"like_count":null,"attire":null,"website":null,"price":null}
  _totalLabel.text = [NSString stringWithFormat:@"Total: %@", [self.dataCenter.parsedResponse objectForKey:@"checkins_count"]];
  _friendsLabel.text = [NSString stringWithFormat:@"Friends: %@", [self.dataCenter.parsedResponse objectForKey:@"checkins_friend_count"]];
  _likesLabel.text = [NSString stringWithFormat:@"Likes: %@", [self.dataCenter.parsedResponse objectForKey:@"like_count"]];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[self.items objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell", [self class]];
  UITableViewCell *cell = nil;
  cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
  }
  
  NSString *distance = [NSString stringWithFormat:@"%.2fmi", [[[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"distance"] floatValue]];
  cell.textLabel.text = @"Distance";
  cell.detailTextLabel.text = distance;
  return cell;
}

#pragma mark MoogleDataCenterDelegate
- (void)dataCenterDidFinish:(ASIHTTPRequest *)request {
  NSDictionary *responseDict = [[CJSONDeserializer deserializer] deserialize:[request responseData] error:nil];
  
  DLog(@"Successfully got place with response: %@", responseDict);
  [self updateHeaderView];
  
  // Update Table Cells
  [self.sections removeAllObjects];
  [self.sections addObject:[responseDict objectForKey:@"name"]];
  
  NSArray *items = [NSArray arrayWithObject:[NSDictionary dictionaryWithObject:[responseDict objectForKey:@"distance"] forKey:@"distance"]];
  
  [self.items removeAllObjects];
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
  
  RELEASE_SAFELY (_placeId);
  
  // UI
  RELEASE_SAFELY(_checkinHereButton);
  RELEASE_SAFELY (_totalLabel);
  RELEASE_SAFELY (_friendsLabel);
  RELEASE_SAFELY (_likesLabel);
  
  // Table
  RELEASE_SAFELY(_tableView);
  RELEASE_SAFELY(_sections);
  RELEASE_SAFELY(_items);
  [super dealloc];
}

@end
