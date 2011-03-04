//
//  PlaceViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceViewController.h"
#import "LauncherViewController.h"

#import "PlaceInfoViewController.h"
#import "PlaceActivityViewController.h"
#import "PlaceFeedViewController.h"
#import "PlaceReviewsViewController.h"

#import "LocationManager.h"

static UIImage *_btnNormal;
static UIImage *_btnSelected;

@interface PlaceViewController (Private)

- (void)setupCheckinHereButton;
- (void)setupTabView;
- (void)setupTabButtons;
- (void)selectTab:(id)sender;
- (void)scrolledToTabAtIndex:(NSInteger)index;

- (void)setupPlaceInfo;
- (void)setupPlaceActivity;
- (void)setupPlaceFeed;
- (void)setupPlaceReviews;

@end

@implementation PlaceViewController

@synthesize placeId = _placeId;
@synthesize placeName = _placeName;

+ (void)initialize {
  _btnNormal = [[[UIImage imageNamed:@"btn_filter.png"] stretchableImageWithLeftCapWidth:37 topCapHeight:14] retain];
  _btnSelected = [[[UIImage imageNamed:@"btn_filter_selected.png"] stretchableImageWithLeftCapWidth:37 topCapHeight:14] retain];
}

- (id)init {
  self = [super init];
  if (self) {
    _placeScrollView = [[UIScrollView alloc] init];
    _placeInfoViewController = [[PlaceInfoViewController alloc] init];
    _placeActivityViewController = [[PlaceActivityViewController alloc] init];
    _placeFeedViewController = [[PlaceFeedViewController alloc] init];
    _placeReviewsViewController = [[PlaceReviewsViewController alloc] init];
    _tabView = [[UIView alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = self.placeName;
  
  // Tell Launcher about our activePlaceId
  APP_DELEGATE.launcherViewController.activePlace = self;
  
  [self setupTabView];
  
  // Setup Place Scroll View
  _placeScrollView.frame = CGRectMake(0, _tabView.height, self.view.width, self.view.height - _tabView.height - 44.0);
  
  _placeScrollView.contentSize = CGSizeMake(1280.0, _placeScrollView.height);
  _placeScrollView.showsVerticalScrollIndicator = NO;
  _placeScrollView.showsHorizontalScrollIndicator = NO;
  _placeScrollView.bounces = NO;
  _placeScrollView.scrollEnabled = YES;
  _placeScrollView.pagingEnabled = YES;
  _placeScrollView.delegate = self;
  
  [self.view addSubview:_placeScrollView];
  
  // Setup tab controllers
  [self setupPlaceInfo];
  [self setupPlaceActivity];
  [self setupPlaceFeed];
  [self setupPlaceReviews];
  
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

- (void)setupPlaceReviews {
  _placeReviewsViewController.placeId = self.placeId;
  _placeReviewsViewController.viewport = CGRectMake(0, 0, _placeScrollView.width, _placeScrollView.height);
  _placeReviewsViewController.view.frame = CGRectMake(960, 0, _placeScrollView.width, _placeScrollView.height);
  [_placeScrollView addSubview:_placeReviewsViewController.view];
}

- (void)setupTabView {
  _tabView.frame = CGRectMake(0, 0, 320.0, 44.0);
  _tabView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"filter_gradient.png"]];
  
  [self setupTabButtons];
  
  [self.view addSubview:_tabView];
}

- (void)setupTabButtons {
  _infoButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 8, 75, 29)];
  _activityButton = [[UIButton alloc] initWithFrame:CGRectMake(83, 8, 75, 29)];
  _feedButton = [[UIButton alloc] initWithFrame:CGRectMake(162, 8, 75, 29)];
  _reviewsButton = [[UIButton alloc] initWithFrame:CGRectMake(241, 8, 75, 29)];
  
  _infoButton.adjustsImageWhenHighlighted = NO;
  _activityButton.adjustsImageWhenHighlighted = NO;
  _feedButton.adjustsImageWhenHighlighted = NO;
  _reviewsButton.adjustsImageWhenHighlighted = NO;
  
  [_infoButton addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
  [_activityButton addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
  [_feedButton addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
  [_reviewsButton addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
  
  [_infoButton setBackgroundImage:_btnNormal forState:UIControlStateNormal];
  [_infoButton setBackgroundImage:_btnSelected forState:UIControlStateHighlighted];
  [_infoButton setBackgroundImage:_btnSelected forState:UIControlStateSelected];
  [_activityButton setBackgroundImage:_btnNormal forState:UIControlStateNormal];
  [_activityButton setBackgroundImage:_btnSelected forState:UIControlStateHighlighted];
  [_activityButton setBackgroundImage:_btnSelected forState:UIControlStateSelected];
  [_feedButton setBackgroundImage:_btnNormal forState:UIControlStateNormal];
  [_feedButton setBackgroundImage:_btnSelected forState:UIControlStateHighlighted];
  [_feedButton setBackgroundImage:_btnSelected forState:UIControlStateSelected];
  [_reviewsButton setBackgroundImage:_btnNormal forState:UIControlStateNormal];
  [_reviewsButton setBackgroundImage:_btnSelected forState:UIControlStateHighlighted];
  [_reviewsButton setBackgroundImage:_btnSelected forState:UIControlStateSelected];
  
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
  
  [_reviewsButton setTitle:@"Reviews" forState:UIControlStateNormal];
  [_reviewsButton setTitleColor:FILTER_COLOR_BLUE forState:UIControlStateNormal];
  _reviewsButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
  _reviewsButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
  
  [_tabView addSubview:_infoButton];
  [_tabView addSubview:_activityButton];
  [_tabView addSubview:_feedButton];
  [_tabView addSubview:_reviewsButton];
}

- (void)selectTab:(id)sender {
  DLog(@"Button: %@", sender);
  [_infoButton setSelected:NO];
  [_activityButton setSelected:NO];
  [_feedButton setSelected:NO];
  [_reviewsButton setSelected:NO];
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
  } else if ([sender isEqual:_reviewsButton]) {
    [_placeScrollView scrollRectToVisible:_placeReviewsViewController.view.frame animated:YES];
    _visibleViewController = _placeReviewsViewController;
  }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
  // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
  // which a scroll event generated from the user hitting the page control triggers updates from
  // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
  
  // Switch the indicator when more than 50% of the previous/next page is visible
  CGFloat pageWidth = _placeScrollView.frame.size.width;
  int page = floor((_placeScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
  if (_placeScrollView.dragging) {
    [self scrolledToTabAtIndex:page];
  }
}

- (void)scrolledToTabAtIndex:(NSInteger)index {
  [_infoButton setSelected:NO];
  [_activityButton setSelected:NO];
  [_feedButton setSelected:NO];
  [_reviewsButton setSelected:NO];
  
  switch (index) {
    case 0:
      [_infoButton setSelected:YES];
      break;
    case 1:
      [_activityButton setSelected:YES];
      break;
    case 2:
      [_feedButton setSelected:YES];
      break;
    case 3:
      [_reviewsButton setSelected:YES];
      break;
    default:
      [_infoButton setSelected:YES];
      break;
  }
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
}

- (void)dealloc {  
  RELEASE_SAFELY(_placeInfoViewController);
  RELEASE_SAFELY(_placeActivityViewController);
  RELEASE_SAFELY(_placeFeedViewController);
  RELEASE_SAFELY(_placeReviewsViewController);
  RELEASE_SAFELY(_placeName);
  RELEASE_SAFELY (_placeId);
  
  // UI
  RELEASE_SAFELY(_placeScrollView);
  RELEASE_SAFELY(_checkinHereButton);
  RELEASE_SAFELY(_tabView);
  RELEASE_SAFELY(_infoButton);
  RELEASE_SAFELY(_activityButton);
  RELEASE_SAFELY(_feedButton);
  RELEASE_SAFELY(_reviewsButton);
  [super dealloc];
}

@end
