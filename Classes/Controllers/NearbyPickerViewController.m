//
//  NearbyPickerViewController.m
//  Moogle
//
//  Created by Peter Shih on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NearbyPickerViewController.h"

@interface NearbyPickerViewController (Private)

- (void)getNearbyPlaces;

@end

@implementation NearbyPickerViewController

@synthesize nearbyRequest = _nearbyRequest;
@synthesize delegate = _delegate;

- (id)init {
  self = [super init];
  if (self) {
    _distance = [@"2" retain]; // default to 1 mile
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.frame = CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT_WITH_NAV + 49.0);

  // Table
  [self setupTableViewWithFrame:self.view.frame andStyle:UITableViewStylePlain andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  [self setupPullRefresh];
  
  [self setupSearchDisplayController];
  
  [self setupLoadingAndEmptyViews];
  
  [self reloadCardController];
  
  [self setupDistanceButton];
}

#pragma mark Distance Filter
- (void)toggleDistance {
  UIActionSheet *distanceActionSheet = [[UIActionSheet alloc] initWithTitle:@"How Far Away?" delegate:self cancelButtonTitle:@"Nevermind" destructiveButtonTitle:nil otherButtonTitles:@"1 miles", @"2 miles", @"5 miles", nil];
  [distanceActionSheet showInView:[APP_DELEGATE.launcherViewController view]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  NSLog(@"button: %d", buttonIndex);
  switch (buttonIndex) {
    case 0:
      _distance = [@"1" retain];
      break;
    case 1:
      _distance = [@"2" retain];
      break;
    case 2:
      _distance = [@"5" retain];
      break;
    case 3:
    default:
      break;
  }
  
  [_distanceButton setTitle:[NSString stringWithFormat:@"%@ miles", _distance]];
  [self reloadCardController];
}

// Subclasses may implement
- (void)setupLoadingAndEmptyViews {
  self.emptyView.frame = self.view.frame;
  self.loadingView.frame = self.view.frame;
}

- (void)reloadCardController {
  [super reloadCardController];
  
  [self getNearbyPlaces];
}

- (void)getNearbyPlaces {
  CGFloat lat = [APP_DELEGATE.locationManager latitude];
  CGFloat lng = [APP_DELEGATE.locationManager longitude];
//  NSInteger distance = [APP_DELEGATE.locationManager distance];
  
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  [params setObject:[NSString stringWithFormat:@"%f", lat] forKey:@"lat"];
  [params setObject:[NSString stringWithFormat:@"%f", lng] forKey:@"lng"];
//  [params setObject:[NSString stringWithFormat:@"%d", distance] forKey:@"distance"];
  [params setObject:_distance forKey:@"distance"];
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/places/nearby", MOOGLE_BASE_URL, API_VERSION];  
  self.nearbyRequest = [RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self.dataCenter];
  [[RemoteOperation sharedInstance] addRequestToQueue:self.nearbyRequest];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  Place *selectedPlace = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  
  if (self.delegate) {
    [self.delegate retain];
    if ([self.delegate respondsToSelector:@selector(nearbyPickedWithPlace:)]) {
        [self.delegate performSelector:@selector(nearbyPickedWithPlace:) withObject:selectedPlace];
    }
    [self.delegate release];
  }
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
  if(_nearbyRequest) {
    [_nearbyRequest clearDelegatesAndCancel];
    [_nearbyRequest release], _nearbyRequest = nil;
  }
  
  [super dealloc];
}


@end
