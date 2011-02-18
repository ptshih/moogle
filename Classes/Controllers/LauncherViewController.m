//
//  LauncherViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LauncherViewController.h"
#import "MeViewController.h"
#import "NearbyViewController.h"
#import "FriendsViewController.h"
#import "Constants.h"

#define kNumberOfPages 3 // We have 3 cards for now: Timeline | Me | Trends

@interface LauncherViewController (Private)

- (void)zoomIn:(UINavigationController *)card;
- (void)zoomOut:(UINavigationController *)card;
- (void)zoomOutBeforeScrolling;
- (void)zoomInAfterScrolling;
- (void)updateCards;

@end

@implementation LauncherViewController

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;

// Cards
@synthesize meViewController = _meViewController;
@synthesize nearbyViewController = _nearbyViewController;
@synthesize friendsViewController = _friendsViewController;

@synthesize cards = _cards;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _meViewController = [[MeViewController alloc] init];
    _nearbyViewController = [[NearbyViewController alloc] init];
    _friendsViewController = [[FriendsViewController alloc] init];
    _previousPage = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastSelectedCard"]; // Start at last selected card
    _isZoomed = NO;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.frame = CGRectMake(0, 20, self.view.width, self.view.height);
  
  // Gestures
//  [self addGestures];
  
  // Setup Page Control
  self.pageControl.numberOfPages = kNumberOfPages;
  self.pageControl.currentPage = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastSelectedCard"]; // Start at last selected card
  
  // Setup Scroll/Paging View
  self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * kNumberOfPages, self.scrollView.frame.size.height);
  self.scrollView.contentOffset = CGPointMake(kCardWidth * self.pageControl.currentPage, 0); // start at page 1
  self.scrollView.scrollsToTop = NO;
  
  // Configure the three cards
  UINavigationController *nearbyNavController = [[UINavigationController alloc] initWithRootViewController:self.nearbyViewController];
  nearbyNavController.view.frame = CGRectMake(kCardWidth * 0, 0, self.scrollView.width, self.scrollView.height);
  
  UINavigationController *meNavController = [[UINavigationController alloc] initWithRootViewController:self.meViewController];
  meNavController.view.frame = CGRectMake(kCardWidth * 1, 0, self.scrollView.width, self.scrollView.height);
  
  UINavigationController *trendsNavController = [[UINavigationController alloc] initWithRootViewController:self.friendsViewController];
  trendsNavController.view.frame = CGRectMake(kCardWidth * 2, 0, self.scrollView.width, self.scrollView.height);
  
  // Add the three cards
  [self.scrollView addSubview:meNavController.view];
  [self.scrollView addSubview:nearbyNavController.view];
  [self.scrollView addSubview:trendsNavController.view];
  
  self.cards = [NSArray arrayWithObjects:nearbyNavController, meNavController, trendsNavController, nil];
  
  [meNavController release];
  [nearbyNavController release];
  [trendsNavController release];
}

- (void)reloadCheckins {
  [self.meViewController getCheckins];
}

- (void)clearAllCachedData {
  for (UINavigationController *card in self.cards) {
    if ([[card topViewController] respondsToSelector:@selector(clearCachedData)]) {
      [[card topViewController] performSelector:@selector(clearCachedData)];
    }
  }
}

//- (void)addGestures {
//  UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleZoom:)];
//  doubleTapGestureRecognizer.numberOfTapsRequired = 2;
//  
//}

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
  
  int lastPage = self.pageControl.currentPage;
	
  // Switch the indicator when more than 50% of the previous/next page is visible
  CGFloat pageWidth = self.scrollView.frame.size.width;
  int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
  self.pageControl.currentPage = page;
  
  if (lastPage == 0 && page != 0) {
    id visibleViewController = [self.cards objectAtIndex:lastPage];
    if ([[visibleViewController topViewController] respondsToSelector:@selector(hideSearchKeyboard)]) {
      [[visibleViewController topViewController] performSelector:@selector(hideSearchKeyboard)];
    }    
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
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)dealloc {
  RELEASE_SAFELY (_scrollView);
  RELEASE_SAFELY (_pageControl);
  RELEASE_SAFELY (_meViewController);
  RELEASE_SAFELY (_nearbyViewController);
  RELEASE_SAFELY (_friendsViewController);
  RELEASE_SAFELY (_cards);
  [super dealloc];
}


@end
