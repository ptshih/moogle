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
#import "KupoCell.h"

@interface MeViewController (Private)

- (void)setupButtons;
- (void)showPlaceWithId:(NSString *)placeId andName:(NSString *)placeName;

@end

@implementation MeViewController

@synthesize dataCenter = _dataCenter;
@synthesize kupoRequest = _kupoRequest;

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
  [self setupPullRefresh];

}

#pragma mark CardViewController
- (void)reloadCardController {
  [super reloadCardController];
  
  [self getKupos];
}

- (void)setupButtons {  
  // Setup Logout button
  UIBarButtonItem *logoutButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_checkin.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(logout)] autorelease];
  self.navigationItem.leftBarButtonItem = logoutButton;
}

- (void)getKupos {
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/moogle/kupos", MOOGLE_BASE_URL, API_VERSION];
  
  self.kupoRequest = [RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self.dataCenter];
  [[RemoteOperation sharedInstance] addRequestToQueue:self.kupoRequest];
}

- (void)showPlaceWithId:(NSString *)placeId andName:(NSString *)placeName {
  PlaceViewController *pvc = [[PlaceViewController alloc] init];
  pvc.placeId = placeId;
  pvc.placeName = placeName;
  [self.navigationController pushViewController:pvc animated:YES];
  [pvc release];  
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  [self showPlaceWithId:[[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"place_id"] andName:[[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"place_name"]];
}

#pragma mark UITableView Stuff
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [KupoCell rowHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  KupoCell *cell = nil;
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell_%d", [self class], indexPath.section];
  
  cell = (KupoCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[KupoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
  }
  
  NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [item valueForKey:@"user_facebook_id"]]];
  UIImage *image = [self.imageCache getImageWithURL:url];
  if (!image) {
    if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
      [self.imageCache cacheImageWithURL:url forIndexPath:indexPath];
    }
    image = nil;
  }
  
  [KupoCell fillCell:cell withDictionary:item withImage:image];
  
  return cell;
}

#pragma mark MoogleDataCenterDelegate
- (void)dataCenterDidFinish:(ASIHTTPRequest *)request {
  [self.sections removeAllObjects];
  [self.sections addObject:@"Checkins"];
  
  [self.items removeAllObjects];
  [self.items addObject:self.dataCenter.responseArray];
  [self.tableView reloadData];
  
  // Update State Machine
  
  [self dataSourceDidLoad];
}

- (void)dataCenterDidFail:(ASIHTTPRequest *)request {
  [self dataSourceDidLoad];
}

#pragma mark ImageCacheDelegate
- (void)loadImagesForOnScreenRows {
  NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
  
  for (NSIndexPath *indexPath in visibleIndexPaths) {
    NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [item valueForKey:@"user_facebook_id"]]];
    
    if (![self.imageCache getImageWithURL:url]) {
      [self.imageCache cacheImageWithURL:url forIndexPath:indexPath];
    }
  }
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
  RELEASE_SAFELY(_kupoRequest);
  [super dealloc];
}


@end
