//
//  LauncherViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LauncherViewController.h"
#import "CheckinsViewController.h"
#import "PlacesViewController.h"
#import "DiscoverViewController.h"
#import "MeViewController.h"
#import "Constants.h"
#import "CardTabBar.h"
#import "CheckinHereViewController.h"
#import "PlaceViewController.h"
#import "Place.h"

@interface LauncherViewController (Private)

- (void)addGestures;
- (void)zoomIn:(UINavigationController *)card;
- (void)zoomOut:(UINavigationController *)card;
- (void)zoomOutBeforeScrolling;
- (void)zoomInAfterScrolling;
- (void)updateCards;
- (void)scrollToCardAtIndex:(NSInteger)index;
- (void)setActiveCardTab;

- (void)showCheckinHereModal;

@end

@implementation LauncherViewController

@synthesize scrollView = _scrollView;
@synthesize cardTabBar = _cardTabBar;

// Cards
@synthesize checkinsViewController = _checkinsViewController;
@synthesize placesViewController = _placesViewController;
@synthesize discoverViewController = _discoverViewController;
@synthesize meViewController = _meViewController;

@synthesize activePlace = _activePlace;
@synthesize cards = _cards;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _checkinsViewController = [[CheckinsViewController alloc] init];
    _placesViewController = [[PlacesViewController alloc] init];
    _discoverViewController = [[DiscoverViewController alloc] init];
    _meViewController = [[MeViewController alloc] init];
    _previousPage = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastSelectedCard"]; // Start at last selected card
    
    _isQuickScroll = NO;
    
    _activePlace = nil;
    
    _checkinHereViewController = nil;

    self.view.frame = CGRectMake(0, 20, self.view.width, self.view.height);
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Setup Current Page
  _currentPage = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastSelectedCard"]; // Start at last selected card
  
  [self setActiveCardTab];
  
  // Setup Scroll/Paging View
  self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * NUMBER_OF_CARDS, self.scrollView.frame.size.height);
  self.scrollView.contentOffset = CGPointMake(CARD_WIDTH * _currentPage, 0); // start at page 1
  self.scrollView.scrollsToTop = NO;
  
  // Configure the cards (CHECK ORDERING)
  _checkinsNavController = [[UINavigationController alloc] initWithRootViewController:self.checkinsViewController];
  _checkinsNavController.view.frame = CGRectMake(CARD_WIDTH * 0, 0, self.scrollView.width, self.scrollView.height);
  
  _placesNavController = [[UINavigationController alloc] initWithRootViewController:self.placesViewController];
  _placesNavController.view.frame = CGRectMake(CARD_WIDTH * 1, 0, self.scrollView.width, self.scrollView.height);
  
  _discoverNavController = [[UINavigationController alloc] initWithRootViewController:self.discoverViewController];
  _discoverNavController.view.frame = CGRectMake(CARD_WIDTH * 2, 0, self.scrollView.width, self.scrollView.height);
  
  _meNavController = [[UINavigationController alloc] initWithRootViewController:self.meViewController];
  _meNavController.view.frame = CGRectMake(CARD_WIDTH * 3, 0, self.scrollView.width, self.scrollView.height);
  
  _checkinsNavController.delegate = self.checkinsViewController;
  _placesNavController.delegate = self.placesViewController;
  _discoverNavController.delegate = self.discoverViewController;
  _meNavController.delegate = self.meViewController;
  
  
  // Add the three cards
  [self.scrollView addSubview:_checkinsNavController.view];
  [self.scrollView addSubview:_placesNavController.view];
  [self.scrollView addSubview:_discoverNavController.view];
  [self.scrollView addSubview:_meNavController.view];
  
  self.cards = [NSArray arrayWithObjects:_checkinsNavController, _placesNavController, _discoverNavController, _meNavController, nil];
  
  // Gestures
//  [self addGestures];
}

- (void)showCheckinHereModal {
  // If there is an activePlace, show checkinHere
  // Otherwise show nearby places modal
  id visibleViewController = [[self.cards objectAtIndex:_currentPage] topViewController];
  Place *activePlace = nil;
  if ([visibleViewController isKindOfClass:[PlaceViewController class]]) {
    activePlace = [visibleViewController place];
  }
  
  CheckinHereViewController *checkinHereViewController = [[CheckinHereViewController alloc] init];
  checkinHereViewController.place = activePlace;
  UINavigationController *checkinHereNavController = [[UINavigationController alloc] initWithRootViewController:checkinHereViewController];
  
  [self presentModalViewController:checkinHereNavController animated:YES];
  [checkinHereViewController release];
  [checkinHereNavController release];
}

- (void)clearAllCachedData {
  for (UINavigationController *card in self.cards) {
    [card popToRootViewControllerAnimated:NO];
    if ([[card topViewController] respondsToSelector:@selector(clearCachedData)]) {
      [[card topViewController] performSelector:@selector(clearCachedData)];
    }
  }
}

- (void)addGestures {
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollToTop)];
  tapGestureRecognizer.numberOfTapsRequired = 2;
  UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 160, 44)];
  statusView.backgroundColor = [UIColor clearColor];
  [statusView addGestureRecognizer:tapGestureRecognizer];
  [self.view addSubview:statusView];
  [statusView release];
  [tapGestureRecognizer release];
}

- (void)scrollToTop {
  id visibleViewController = [self.cards objectAtIndex:_currentPage];
  if ([[visibleViewController topViewController] respondsToSelector:@selector(tableView)]) {
    [[(UITableViewController *)[visibleViewController topViewController] tableView] scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
  }
}

- (void)zoomIn:(UINavigationController *)card {
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.1];
  card.view.transform = CGAffineTransformMakeScale(1,1);
  card.view.layer.cornerRadius = 0;
  card.view.layer.masksToBounds = YES;
  [UIView commitAnimations];
  
  // iOS4 ONLY
  //  [UIView animateWithDuration:0.2
  //      animations:^{
  //        card.navigationBar.hidden = NO;
  //        card.view.transform = CGAffineTransformMakeScale(1,1);
  //        card.topViewController.view.layer.cornerRadius = 0;
  //        card.topViewController.view.layer.masksToBounds = YES;
  //      }
  //      completion:^(BOOL finished){ 
  //        card.navigationBar.hidden = NO;
  //      }];
}

- (void)zoomOut:(UINavigationController *)card {
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.2];
  card.view.transform = CGAffineTransformMakeScale(0.90,0.90);
  card.view.layer.cornerRadius = 6;
  card.view.layer.masksToBounds = YES;
  [UIView commitAnimations];
  
  // iOS4 ONLY
  //  [UIView animateWithDuration:0.2
  //      animations:^{
  //        card.view.transform = CGAffineTransformMakeScale(0.9,0.915);
  //        card.topViewController.view.layer.cornerRadius = 6;
  //        card.topViewController.view.layer.masksToBounds = YES;
  //      }
  //      completion:^(BOOL finished){ 
  //        card.navigationBar.hidden = YES;
  //      }];
}

#pragma mark Card Tab Bar
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
  if (!item) {
    // This is the center action button
    [self showCheckinHereModal];
    return;
  }
  
  _isQuickScroll = YES;
  
  NSUInteger translatedIndex = ([tabBar.items indexOfObject:item] > 1) ? [tabBar.items indexOfObject:item] - 1 : [tabBar.items indexOfObject:item];
  [self scrollToCardAtIndex:translatedIndex];
}

- (void)scrollToCardAtIndex:(NSInteger)index {
  if (_currentPage == index) return; // Don't scroll if it's the same page
  
  [self.scrollView scrollRectToVisible:[[[self.cards objectAtIndex:index] view] frame] animated:YES];
  
  [self zoomOutBeforeScrolling];
}

- (void)setActiveCardTab {
  NSUInteger translatedIndex = (_currentPage > 1) ? _currentPage + 1 : _currentPage;
  self.cardTabBar.selectedItem = [self.cardTabBar.items objectAtIndex:translatedIndex];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
  // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
  // which a scroll event generated from the user hitting the page control triggers updates from
  // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
  if (self.scrollView.contentOffset.x < 0 || self.scrollView.contentOffset.x > (CARD_WIDTH * (NUMBER_OF_CARDS - 1))) return;
  
  // Switch the indicator when more than 50% of the previous/next page is visible
  CGFloat pageWidth = self.scrollView.frame.size.width;
  int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
  _currentPage = page;
  if (!_isQuickScroll) {
    [self setActiveCardTab];
  }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {  
  [self zoomOutBeforeScrolling];
}

// At the end of scroll animation, load the active view
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [self zoomInAfterScrolling];
}

// Sometimes scrollViewDidEndDecelerating doesn't get called but this does instead
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  if (!decelerate) {
    [self zoomInAfterScrolling];
  }
}

// This is called when the scrolling stops after tapping a navigation button
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
  [self zoomInAfterScrolling];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
  // Fire off something early (before the scroll view settles)
}

- (void)zoomOutBeforeScrolling {
  _previousPage = _currentPage;
  
  // When the user begins scrolling, zoom into card view
  for (UINavigationController *card in self.cards) {
    [self zoomOut:card];
  }
}

- (void)zoomInAfterScrolling {
  if (_isQuickScroll) {
    _isQuickScroll = NO;
    [self setActiveCardTab];
  }
  // When the card is finished paging, zoom it out to take the full screen
  for (UINavigationController *card in self.cards) {
    [self zoomIn:card];
  }
  
  // Only perform unload/reload if the card page actually changed
  if (_currentPage != _previousPage) {    
    [self updateCards];
  }
}

- (void)reloadVisibleCard {
  // Tell the new visible controller to reload it's data if it responds to it
  id visibleViewController = [self.cards objectAtIndex:_currentPage];
  if ([[visibleViewController topViewController] respondsToSelector:@selector(reloadCardController)]) {
    [[visibleViewController topViewController] performSelector:@selector(reloadCardController)];
  }
  
  if ([[visibleViewController topViewController] isKindOfClass:[PlaceViewController class]]) {
    self.scrollView.scrollEnabled = NO;
  } else {
    self.scrollView.scrollEnabled = YES;
  }
}

- (void)updateCards {
  // Tell the previous controller to unload any data if it responds to it
  id previousViewController = [self.cards objectAtIndex:_previousPage];
  if ([[previousViewController topViewController] respondsToSelector:@selector(unloadCardController)]) {
    [[previousViewController topViewController] performSelector:@selector(unloadCardController)];
  }
  
  // Tell the new visible controller to reload it's data if it responds to it
  id visibleViewController = [self.cards objectAtIndex:_currentPage];
  if ([[visibleViewController topViewController] respondsToSelector:@selector(reloadCardController)]) {
    [[visibleViewController topViewController] performSelector:@selector(reloadCardController)];
  }
  
  if ([[visibleViewController topViewController] isKindOfClass:[PlaceViewController class]]) {
    self.scrollView.scrollEnabled = NO;
  } else {
    self.scrollView.scrollEnabled = YES;
  }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc. that aren't in use.
#ifdef CLEAR_ALL_CACHED_DATA_ON_WARNING
  [self clearAllCachedData];
#endif
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)dealloc {
  RELEASE_SAFELY(_checkinsNavController);
  RELEASE_SAFELY(_placesNavController);
  RELEASE_SAFELY(_discoverNavController);
  RELEASE_SAFELY(_meNavController);
  RELEASE_SAFELY(_checkinHereViewController);
  RELEASE_SAFELY (_scrollView);
  RELEASE_SAFELY(_cardTabBar);
  RELEASE_SAFELY (_meViewController);
  RELEASE_SAFELY (_placesViewController);
  RELEASE_SAFELY (_checkinsViewController);
  RELEASE_SAFELY(_discoverViewController);
  RELEASE_SAFELY (_cards);
  [super dealloc];
}


@end
