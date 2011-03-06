//
//  CheckinsViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MeViewController.h"

#import "PlaceViewController.h"

#import "MeDataCenter.h"

@interface MeViewController (Private)

- (void)getProfilePicture;
- (void)setupViews;
- (void)setupButtons;
- (void)updateLabels;
- (void)showPlaceWithId:(NSString *)placeId andName:(NSString *)placeName;

@end

@implementation MeViewController

@synthesize dataCenter = _dataCenter;
@synthesize meRequest = _meRequest;
@synthesize lastCheckin = _lastCheckin;
@synthesize userStats = _userStats;

- (id)init {
  self = [super init];
  if (self) {
    _dataCenter = [[MeDataCenter alloc ]init];
    _dataCenter.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupViews];
  [self setupButtons];
  [self getProfilePicture];
  
  // Table
  CGRect tableFrame = CGRectMake(0, 120, CARD_WIDTH, CARD_HEIGHT_WITH_NAV - 120);
  [self setupTableViewWithFrame:tableFrame andStyle:UITableViewStylePlain andSeparatorStyle:UITableViewCellSeparatorStyleNone];
//  [self setupPullRefresh];

}

- (void)setupViews {
  _nameLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"facebookName"];
  _checkinsView.layer.cornerRadius = 5.0;
  _placesView.layer.cornerRadius = 5.0;
  _friendsView.layer.cornerRadius = 5.0;
}

- (void)setupButtons {  
  // Setup Logout button
  UIBarButtonItem *logoutButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_checkin.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(logout)] autorelease];
  self.navigationItem.leftBarButtonItem = logoutButton;
}

- (void)getProfilePicture {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  NSString *facebookId = [[NSUserDefaults standardUserDefaults] valueForKey:@"facebookId"];
  UIImage *profileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", facebookId]]]];
  
  [self performSelectorOnMainThread:@selector(updateProfilePicture:) withObject:profileImage waitUntilDone:YES];
  [pool release];
}

- (void)updateProfilePicture:(UIImage *)profileImage {
  _profilePicture.image = profileImage;
}

- (void)updateLabels {
  _checkinsLabel.text = [[_userStats objectForKey:@"total_checkins"] stringValue];
  _placesLabel.text = [[_userStats objectForKey:@"you_total_unique_places"] stringValue];
  _friendsLabel.text = [[_userStats objectForKey:@"you_friend_total_unique_places"] stringValue];
}

#pragma mark CardViewController
- (void)reloadCardController {
  [super reloadCardController];
  
  [self getMe];
}

- (void)getMe {
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/moogle/me", MOOGLE_BASE_URL, API_VERSION];
  
  self.meRequest = [RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self.dataCenter];
  [[RemoteOperation sharedInstance] addRequestToQueue:self.meRequest];
}

- (void)showPlaceWithId:(NSString *)placeId andName:(NSString *)placeName {
  PlaceViewController *pvc = [[PlaceViewController alloc] init];
//  pvc.place = place;
  [self.navigationController pushViewController:pvc animated:YES];
  [pvc release];  
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark UITableView Stuff
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//  return [KupoCell rowHeight];
  return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell_%d", [self class], indexPath.section];
  
  cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
    cell.backgroundView = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"table_cell_bg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:30]] autorelease];
    cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"table_cell_bg_selected.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:30]] autorelease];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  
  id item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

  
  cell.textLabel.numberOfLines = 100;
  
  switch (indexPath.row) {
    case 0:
      cell.textLabel.text = @"Your Top Places";
      break;
    case 1:
      cell.textLabel.text = @"Your Friends Top Places";
      break;
    case 2:
      cell.textLabel.text = @"Friends You Have Tagged";
      break;
    case 3:
      cell.textLabel.text = @"Friends Who Tagged You";
      break;
    default:
      break;
  }
  
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [item count]];
  
  return cell;
}

#pragma mark MoogleDataCenterDelegate
- (void)dataCenterDidFinish:(ASIHTTPRequest *)request {
  [self.sections removeAllObjects];
  [self.items removeAllObjects];

  NSArray *item = self.dataCenter.rawResponse;
  
  _lastCheckin = [[item objectAtIndex:0] retain];
  _userStats = [[item objectAtIndex:1] retain];
  
  [self updateLabels];
  
  // Compose Table Structure
  [self.sections addObject:@"Your Social Network Statistics"];
//  NSDictionary *topPlaces = [NSDictionary dictionaryWithObject:[[item objectAtIndex:2] objectForKey:@"you_top_places_array"] forKey:@"Your Top Places"];
//  NSDictionary *friendTopPlaces = [NSDictionary dictionaryWithObject:[[item objectAtIndex:2] objectForKey:@"you_friends_top_places_array"] forKey:@"Friends Top Places"];
//  NSDictionary *youTagged = [NSDictionary dictionaryWithObject:[[item objectAtIndex:2] objectForKey:@"you_tagged_friend_array"] forKey:@"Friends You Tagged"];
//  NSDictionary *friendTagged = [NSDictionary dictionaryWithObject:[[item objectAtIndex:2] objectForKey:@"friend_tagged_you_array"] forKey:@"Friends Who Tagged You"];
//  [self.items addObject:[NSArray arrayWithObjects:topPlaces, friendTopPlaces, youTagged, friendTagged, nil]];
  
  [self.items addObject:[NSArray arrayWithObjects:[[item objectAtIndex:2] objectForKey:@"you_top_places_array"], [[item objectAtIndex:2] objectForKey:@"you_friends_top_places_array"], [[item objectAtIndex:2] objectForKey:@"you_tagged_friend_array"], [[item objectAtIndex:2] objectForKey:@"friend_tagged_you_array"], nil]];

  [self.tableView reloadData];
  
  // Update State Machine
  
  [self dataSourceDidLoad];
}

- (void)dataCenterDidFail:(ASIHTTPRequest *)request {
  [self dataSourceDidLoad];
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
  }
}

- (void)logout {
  _logoutAlert = [[UIAlertView alloc] initWithTitle:@"Logout of Moogle?" message:MOOGLE_LOGOUT_ALERT delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
  [_logoutAlert show];
  [_logoutAlert autorelease];
}

- (void)dealloc {  
  RELEASE_SAFELY(_dataCenter);
  RELEASE_SAFELY(_meRequest);
  RELEASE_SAFELY(_lastCheckin);
  RELEASE_SAFELY(_userStats);
  [super dealloc];
}


@end
