//
//  LauncherViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LauncherViewController.h"
#import "MeViewController.h"
#import "PlacesViewController.h"
#import "CheckinsViewController.h"
#import "TrendsViewController.h"
#import "Constants.h"

#define kNumberOfPages 4

@interface LauncherViewController (Private)

- (void)addGestures;
- (void)zoomIn:(UINavigationController *)card;
- (void)zoomOut:(UINavigationController *)card;
- (void)zoomOutBeforeScrolling;
- (void)zoomInAfterScrolling;
- (void)updateCards;

@end

@implementation LauncherViewController

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize placeLabel = _placeLabel;

// Cards
@synthesize meViewController = _meViewController;
@synthesize placesViewController = _placesViewController;
@synthesize checkinsViewController = _checkinsViewController;
@synthesize trendsViewController = _trendsViewController;

@synthesize cards = _cards;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _meViewController = [[MeViewController alloc] init];
    _placesViewController = [[PlacesViewController alloc] init];
    _checkinsViewController = [[CheckinsViewController alloc] init];
    _trendsViewController = [[TrendsViewController alloc] init];
    _previousPage = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastSelectedCard"]; // Start at last selected card
    _isZoomed = NO;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.frame = CGRectMake(0, 20, self.view.width, self.view.height);
  
  // Setup Page Control
  self.pageControl.numberOfPages = kNumberOfPages;
  self.pageControl.currentPage = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastSelectedCard"]; // Start at last selected card
  
  // Setup Scroll/Paging View
  self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * kNumberOfPages, self.scrollView.frame.size.height);
  self.scrollView.contentOffset = CGPointMake(kCardWidth * self.pageControl.currentPage, 0); // start at page 1
  self.scrollView.scrollsToTop = NO;
  
  // Configure the three cards
  UINavigationController *meNavController = [[UINavigationController alloc] initWithRootViewController:self.meViewController];
  meNavController.view.frame = CGRectMake(kCardWidth * 0, 0, self.scrollView.width, self.scrollView.height);
  
  UINavigationController *placesNavController = [[UINavigationController alloc] initWithRootViewController:self.placesViewController];
  placesNavController.view.frame = CGRectMake(kCardWidth * 1, 0, self.scrollView.width, self.scrollView.height);
  
  UINavigationController *checkinsNavController = [[UINavigationController alloc] initWithRootViewController:self.checkinsViewController];
  checkinsNavController.view.frame = CGRectMake(kCardWidth * 2, 0, self.scrollView.width, self.scrollView.height);
  
  UINavigationController *trendsNavController = [[UINavigationController alloc] initWithRootViewController:self.trendsViewController];
  trendsNavController.view.frame = CGRectMake(kCardWidth * 3, 0, self.scrollView.width, self.scrollView.height);
  
  meNavController.delegate = self.meViewController;
  placesNavController.delegate = self.placesViewController;
  checkinsNavController.delegate = self.checkinsViewController;
  trendsNavController.delegate = self.trendsViewController;
  
  
  // Add the three cards
  [self.scrollView addSubview:meNavController.view];
  [self.scrollView addSubview:placesNavController.view];
  [self.scrollView addSubview:checkinsNavController.view];
  [self.scrollView addSubview:trendsNavController.view];
  
  self.cards = [NSArray arrayWithObjects:meNavController, placesNavController, checkinsNavController, trendsNavController, nil];
  
  [meNavController release];
  [placesNavController release];
  [checkinsNavController release];
  [trendsNavController release];
  
  // Gestures
  [self addGestures];
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
  id visibleViewController = [self.cards objectAtIndex:self.pageControl.currentPage];
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

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
  // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
  // which a scroll event generated from the user hitting the page control triggers updates from
  // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
  
  // Switch the indicator when more than 50% of the previous/next page is visible
  CGFloat pageWidth = self.scrollView.frame.size.width;
  int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
  self.pageControl.currentPage = page;
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
  _previousPage = self.pageControl.currentPage;
  
  // When the user begins scrolling, zoom into card view
  for (UINavigationController *card in self.cards) {
    [self zoomOut:card];
  }
}

- (void)zoomInAfterScrolling {
  // When the card is finished paging, zoom it out to take the full screen
  for (UINavigationController *card in self.cards) {
    [self zoomIn:card];
  }
  
  // Only perform unload/reload if the card page actually changed
  if (self.pageControl.currentPage != _previousPage) {    
    [self updateCards];
  }
}

- (void)reloadVisibleCard {
  // Tell the new visible controller to reload it's data if it responds to it
  id visibleViewController = [self.cards objectAtIndex:self.pageControl.currentPage];
  if ([[visibleViewController topViewController] respondsToSelector:@selector(reloadCardController)]) {
    [[visibleViewController topViewController] performSelector:@selector(reloadCardController)];
  }
}

- (void)updateCards {
  // Tell the previous controller to unload any data if it responds to it
  id previousViewController = [self.cards objectAtIndex:_previousPage];
  if ([[previousViewController topViewController] respondsToSelector:@selector(unloadCardController)]) {
    [[previousViewController topViewController] performSelector:@selector(unloadCardController)];
  }
  
  // Tell the new visible controller to reload it's data if it responds to it
  id visibleViewController = [self.cards objectAtIndex:self.pageControl.currentPage];
  if ([[visibleViewController topViewController] respondsToSelector:@selector(reloadCardController)]) {
    [[visibleViewController topViewController] performSelector:@selector(reloadCardController)];
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
    [_placeLabel release];
    [self setPlaceLabel:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)dealloc {
  RELEASE_SAFELY (_scrollView);
  RELEASE_SAFELY (_pageControl);
  RELEASE_SAFELY(_placeLabel);
  RELEASE_SAFELY (_meViewController);
  RELEASE_SAFELY (_placesViewController);
  RELEASE_SAFELY (_checkinsViewController);
  RELEASE_SAFELY(_trendsViewController);
  RELEASE_SAFELY (_cards);
  [super dealloc];
}


@end
