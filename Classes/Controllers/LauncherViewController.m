//
//  LauncherViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LauncherViewController.h"
#import "CheckinsViewController.h"
#import "NearbyPlacesViewController.h"
#import "TrendsViewController.h"
#import "Constants.h"

#define kNumberOfPages 3 // We have 3 cards for now: Timeline | Me | Trends

@implementation LauncherViewController

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;

// Cards
@synthesize checkinsViewController = _checkinsViewController;
@synthesize nearbyPlacesViewController = _nearbyPlacesViewController;
@synthesize trendsViewController = _trendsViewController;

@synthesize cards = _cards;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _checkinsViewController = [[CheckinsViewController alloc] initWithNibName:@"CheckinsViewController" bundle:nil];
    _nearbyPlacesViewController = [[NearbyPlacesViewController alloc] initWithNibName:@"NearbyPlacesViewController" bundle:nil];
    self.nearbyPlacesViewController.delegate = self;
    _trendsViewController = [[TrendsViewController alloc] initWithNibName:@"TrendsViewController" bundle:nil];
    _currentPage = 0;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Setup Scroll/Paging View
  self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * kNumberOfPages, self.scrollView.frame.size.height);
  self.scrollView.scrollsToTop = NO;
  
  // Setup Page Control
  self.pageControl.numberOfPages = kNumberOfPages;
  self.pageControl.currentPage = 0;
  
  // Configure the three cards
  UINavigationController *checkinsNavController = [[UINavigationController alloc] initWithRootViewController:self.checkinsViewController];
  checkinsNavController.view.frame = CGRectMake(0, 0, self.scrollView.width, self.scrollView.height);
  
  UINavigationController *nearbyNavController = [[UINavigationController alloc] initWithRootViewController:self.nearbyPlacesViewController];
  nearbyNavController.view.frame = CGRectMake(320, 0, self.scrollView.width, self.scrollView.height);
  
  UINavigationController *trendsNavController = [[UINavigationController alloc] initWithRootViewController:self.trendsViewController];
  trendsNavController.view.frame = CGRectMake(640, 0, self.scrollView.width, self.scrollView.height);
  
  // Add the three cards
  [self.scrollView addSubview:checkinsNavController.view];
  [self.scrollView addSubview:nearbyNavController.view];
  [self.scrollView addSubview:trendsNavController.view];
  
  self.cards = [NSArray arrayWithObjects:self.checkinsViewController, self.nearbyPlacesViewController, self.trendsViewController, nil];
}

- (void)reloadCheckins {
  [self.checkinsViewController getCheckins];
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

// At the end of scroll animation, load the active view
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  id visibleViewController = [self.cards objectAtIndex:self.pageControl.currentPage];
  [visibleViewController performSelector:@selector(reloadCardController)];
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
  RELEASE_SAFELY (_checkinsViewController);
  RELEASE_SAFELY (_nearbyPlacesViewController);
  RELEASE_SAFELY (_trendsViewController);
  RELEASE_SAFELY (_cards);
  [super dealloc];
}


@end
