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

- (void)setupButtons;
- (void)showPlaceWithId:(NSString *)placeId andName:(NSString *)placeName;

@end

@implementation MeViewController

@synthesize dataCenter = _dataCenter;
@synthesize meRequest = _meRequest;

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
  
  self.title = @"Moogle Me";
  
  [self setupButtons];
  
  // Table
  CGRect tableFrame = CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT_WITH_NAV);
  [self setupTableViewWithFrame:tableFrame andStyle:UITableViewStylePlain andSeparatorStyle:UITableViewCellSeparatorStyleNone];
//  [self setupPullRefresh];

}

#pragma mark CardViewController
- (void)reloadCardController {
  [super reloadCardController];
  
  [self getMe];
}

- (void)setupButtons {  
  // Setup Logout button
  UIBarButtonItem *logoutButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_checkin.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(logout)] autorelease];
  self.navigationItem.leftBarButtonItem = logoutButton;
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
  return 88.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell_%d", [self class], indexPath.section];
  
  cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
  }
  
  id item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

  
  cell.textLabel.numberOfLines = 100;
  
  switch (indexPath.section) {
    case 0: {
      NSDate *lastCheckinDate = [[NSDate dateWithTimeIntervalSince1970:[[item objectForKey:@"you_last_checkin_time"] integerValue]] humanIntervalSinceNow];
      cell.textLabel.text = [NSString stringWithFormat:@"Your last check in was at: %@ %@", [item objectForKey:@"you_last_checkin_place_name"], lastCheckinDate];
      break;
    }
    case 1:
      cell.textLabel.text = [NSString stringWithFormat:@"Total Checkins: %@", [item objectForKey:@"total_checkins"]];
      break;
    case 2:
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
      break;
    default:
      break;
  }
//  cell.textLabel.text = [NSString stringWithFormat:@"You checked in a total of %@ times, of which %@ checkins were the author. Your friends have tagged you a total of %@ times, and you tagged your friends a total of %@ times. You have visited %@ times in the past, whereas your friends have visited a combined total of %@ places. Your last check in was at %@ %@.", [item objectForKey:@"total_checkins"], [item objectForKey:@"total_authored"], [item objectForKey:@"total_tagged_you"], [item objectForKey:@"total_you_tagged"], [item objectForKey:@"you_total_unique_places"], [item objectForKey:@"you_friend_total_unique_places"], [item objectForKey:@"you_last_checkin_place_name"], [lastCheckinDate humanIntervalSinceNow]];
//  [KupoCell fillCell:cell withDictionary:item withImage:image];
  
  return cell;
}

#pragma mark MoogleDataCenterDelegate
- (void)dataCenterDidFinish:(ASIHTTPRequest *)request {
  [self.sections removeAllObjects];
  [self.items removeAllObjects];

  NSArray *item = self.dataCenter.rawResponse;
  
  // Compose Table Structure
  [self.sections addObject:@"Your Last Check In"];
  [self.items addObject:[NSArray arrayWithObject:[item objectAtIndex:0]]];
  
  [self.sections addObject:@"Your Check In Totals"];
  [self.items addObject:[NSArray arrayWithObject:[item objectAtIndex:1]]];
  
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
  [super dealloc];
}


@end
