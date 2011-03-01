//
//  PlaceViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceViewController.h"
#import "Constants.h"
#import "PlaceInfoViewController.h"
#import "PlaceActivityViewController.h"
#import "PlaceFeedViewController.h"

#import "LocationManager.h"
#import "CheckinHereViewController.h"

@interface PlaceViewController (Private)

- (void)showCheckinHereModal;

- (void)setupCheckinHereButton;
- (void)setupTabView;
- (void)setupTabButtons;
- (void)selectTab:(id)sender;

- (void)setupPlaceInfo;
- (void)setupPlaceActivity;
- (void)setupPlaceFeed;

@end

@implementation PlaceViewController

@synthesize placeId = _placeId;
@synthesize placeName = _placeName;
@synthesize shouldShowCheckinHere = _shouldShowCheckinHere;

- (id)init {
  self = [super init];
  if (self) {
    _placeScrollView = [[UIScrollView alloc] init];
    _placeInfoViewController = [[PlaceInfoViewController alloc] init];
    _placeActivityViewController = [[PlaceActivityViewController alloc] init];
    _placeFeedViewController = [[PlaceFeedViewController alloc] init];
    _tabView = [[UIView alloc] init];
    _shouldShowCheckinHere = NO;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = self.placeName;
  
  [self setupTabView];
  
  // Setup Place Scroll View
  if (_shouldShowCheckinHere) {
    [self setupCheckinHereButton];
    _placeScrollView.frame = CGRectMake(0, _tabView.height, self.view.width, self.view.height - _tabView.height - _checkinHereButton.height);
  } else {
    _placeScrollView.frame = CGRectMake(0, _tabView.height, self.view.width, self.view.height - _tabView.height);
  }
  
  _placeScrollView.contentSize = CGSizeMake(960.0, _placeScrollView.height);
  _placeScrollView.scrollEnabled = NO;
  
  [self.view addSubview:_placeScrollView];
  
  // Setup tab controllers
  [self setupPlaceInfo];
  [self setupPlaceActivity];
  [self setupPlaceFeed];
  
  // Default to PlaceInfo tab
  [_infoButton setSelected:YES];
  _visibleViewController = _placeInfoViewController;
}

- (void)setupPlaceInfo {
  _placeInfoViewController.placeId = self.placeId;
  _placeInfoViewController.viewport = CGRectMake(0, 0, _placeScrollView.width, _placeScrollView.height);
  _placeInfoViewController.view.frame = CGRectMake(0, 0, _placeScrollView.width, _placeScrollView.height);
  [_placeScrollView addSubview:_placeInfoViewController.view];
}

- (void)setupPlaceActivity {
  _placeActivityViewController.placeId = self.placeId;
  _placeActivityViewController.viewport = CGRectMake(0, 0, _placeScrollView.width, _placeScrollView.height);
  _placeActivityViewController.view.frame = CGRectMake(320, 0, _placeScrollView.width, _placeScrollView.height);
  [_placeScrollView addSubview:_placeActivityViewController.view];
}

- (void)setupPlaceFeed {
  _placeFeedViewController.placeId = self.placeId;
  _placeFeedViewController.viewport = CGRectMake(0, 0, _placeScrollView.width, _placeScrollView.height);
  _placeFeedViewController.view.frame = CGRectMake(640, 0, _placeScrollView.width, _placeScrollView.height);
  [_placeScrollView addSubview:_placeFeedViewController.view];
}

- (void)setupTabView {
  _tabView.frame = CGRectMake(0, 0, 320.0, 44.0);
  _tabView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"filter_gradient.png"]];
  
  [self setupTabButtons];
  
  [self.view addSubview:_tabView];
}

- (void)setupTabButtons {
  _infoButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 8, 100, 29)];
  _activityButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 8, 100, 29)];
  _feedButton = [[UIButton alloc] initWithFrame:CGRectMake(215, 8, 100, 29)];
  
  _infoButton.adjustsImageWhenHighlighted = NO;
  _activityButton.adjustsImageWhenHighlighted = NO;
  _feedButton.adjustsImageWhenHighlighted = NO;
  
  [_infoButton addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
  [_activityButton addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
  [_feedButton addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
  
  [_infoButton setBackgroundImage:[UIImage imageNamed:@"btn_filter.png"] forState:UIControlStateNormal];
  [_infoButton setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected.png"] forState:UIControlStateHighlighted];
  [_infoButton setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected.png"] forState:UIControlStateSelected];
  [_activityButton setBackgroundImage:[UIImage imageNamed:@"btn_filter.png"] forState:UIControlStateNormal];
  [_activityButton setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected.png"] forState:UIControlStateHighlighted];
  [_activityButton setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected.png"] forState:UIControlStateSelected];
  [_feedButton setBackgroundImage:[UIImage imageNamed:@"btn_filter.png"] forState:UIControlStateNormal];
  [_feedButton setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected.png"] forState:UIControlStateHighlighted];
  [_feedButton setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected.png"] forState:UIControlStateSelected];
  
  [_infoButton setTitle:@"Info" forState:UIControlStateNormal];
  [_infoButton setTitleColor:FILTER_COLOR_BLUE forState:UIControlStateNormal];
  _infoButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
  _infoButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
  
  [_activityButton setTitle:@"Activity" forState:UIControlStateNormal];
  [_activityButton setTitleColor:FILTER_COLOR_BLUE forState:UIControlStateNormal];
  _activityButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
  _activityButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
  
  [_feedButton setTitle:@"Feed" forState:UIControlStateNormal];
  [_feedButton setTitleColor:FILTER_COLOR_BLUE forState:UIControlStateNormal];
  _feedButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
  _feedButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
  
  [_tabView addSubview:_infoButton];
  [_tabView addSubview:_activityButton];
  [_tabView addSubview:_feedButton];
}

- (void)setupCheckinHereButton {
  _checkinHereButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.height - 37, 320, 37)];
  [_checkinHereButton setBackgroundImage:[UIImage imageNamed:@"bg_navigation.png"] forState:UIControlStateNormal];
  [_checkinHereButton addTarget:self action:@selector(showCheckinHereModal) forControlEvents:UIControlEventTouchUpInside];
  [_checkinHereButton setTitle:@"Checkin Here" forState:UIControlStateNormal];
  [self.view addSubview:_checkinHereButton];
}

- (void)showCheckinHereModal {
  _checkinHereViewController = [[CheckinHereViewController alloc] init];
  _checkinHereViewController.placeId = self.placeId;
  [APP_DELEGATE.launcherViewController presentModalViewController:_checkinHereViewController animated:YES];
}

- (void)selectTab:(id)sender {
  DLog(@"Button: %@", sender);
  [_infoButton setSelected:NO];
  [_activityButton setSelected:NO];
  [_feedButton setSelected:NO];
  [sender setSelected:YES];
  
  if ([sender isEqual:_infoButton]) {
    [_placeScrollView scrollRectToVisible:_placeInfoViewController.view.frame animated:YES];
    _visibleViewController = _placeInfoViewController;
  } else if ([sender isEqual:_activityButton]) {
    [_placeScrollView scrollRectToVisible:_placeActivityViewController.view.frame animated:YES];
    _visibleViewController = _placeActivityViewController;
  } else if ([sender isEqual:_feedButton]) {
    [_placeScrollView scrollRectToVisible:_placeFeedViewController.view.frame animated:YES];
    _visibleViewController = _placeFeedViewController;
  }
  
  [_visibleViewController performSelector:@selector(reloadDataSource)];
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
  [_visibleViewController performSelector:@selector(reloadDataSource)];
}

- (void)dealloc {  
  RELEASE_SAFELY(_checkinHereViewController);
  RELEASE_SAFELY(_placeInfoViewController);
  RELEASE_SAFELY(_placeActivityViewController);
  RELEASE_SAFELY(_placeFeedViewController);
  RELEASE_SAFELY(_placeName);
  RELEASE_SAFELY (_placeId);
  
  // UI
  RELEASE_SAFELY(_placeScrollView);
  RELEASE_SAFELY(_checkinHereButton);
  RELEASE_SAFELY(_tabView);
  RELEASE_SAFELY(_infoButton);
  RELEASE_SAFELY(_activityButton);
  RELEASE_SAFELY(_feedButton);
  [super dealloc];
}

@end
