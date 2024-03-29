    //
//  CardViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CardViewController.h"
#import "Constants.h"

#import "LauncherViewController.h"
#import "PlaceViewController.h"
#import "PlaceTabViewController.h"
#import "WhoViewController.h"
#import "PlacesViewController.h"
#import "DiscoverViewController.h"

@interface CardViewController (Private)

- (void)showLoadingView;
- (void)hideLoadingView;

@end

@implementation CardViewController

@synthesize emptyView = _emptyView;
@synthesize emptyLabel = _emptyLabel;
@synthesize loadingView = _loadingView;
@synthesize loadingLabel = _loadingLabel;
@synthesize loadingSpinner = _loadingSpinner;

- (id)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.frame = CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT);
  self.view.autoresizingMask = UIViewAutoresizingNone;
  self.view.autoresizesSubviews = NO;
  self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
  
  self.navigationController.navigationBar.tintColor = MOOGLE_BLUE_COLOR;
  self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moogle_logo.png"]] autorelease];

  [[NSBundle mainBundle] loadNibNamed:@"EmptyView" owner:self options:nil];
  [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil];
  
  // Setup Empty and Loading View
//  if ([self isKindOfClass:[PlaceTabViewController class]]) {
//    [[NSBundle mainBundle] loadNibNamed:@"EmptyPlaceView" owner:self options:nil];
//    [[NSBundle mainBundle] loadNibNamed:@"LoadingPlaceView" owner:self options:nil];
//  } else if ([self isKindOfClass:[DiscoverViewController class]]) {
//    [[NSBundle mainBundle] loadNibNamed:@"EmptyDiscoverView" owner:self options:nil];
//    [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil];
//    
//    self.loadingView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"grad_loading.png"]];
//  } else if ([self isKindOfClass:[WhoViewController class]]) {
//  } else if ([self isKindOfClass:[PlacesViewController class]]) {
//    [[NSBundle mainBundle] loadNibNamed:@"EmptyView" owner:self options:nil];
//    [[NSBundle mainBundle] loadNibNamed:@"LocationLoadingView" owner:self options:nil];
//    self.emptyView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"grad_loading.png"]];
//    self.loadingView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"grad_loading.png"]];
//  } else {
//    [[NSBundle mainBundle] loadNibNamed:@"EmptyView" owner:self options:nil];
//    [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil];
//    
//    self.emptyView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"grad_loading.png"]];
//    self.loadingView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"grad_loading.png"]];
//  }
  
//  self.loadingView.hidden = YES;
  self.emptyView.hidden = YES;
  [self.view addSubview:self.emptyView];
  [self.view addSubview:self.loadingView];
  self.emptyView.backgroundColor = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"grad_loading.png"]] autorelease];
  self.loadingView.backgroundColor = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"grad_loading.png"]] autorelease];
  self.loadingSpinner.top = self.view.center.y + 20;
}

// Subclasses may implement
- (void)setupLoadingAndEmptyViews {

}

// Called when the user logs out and we need to clear all cached data
// Subclasses should override this method
- (void)clearCachedData {
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
  [self updateState];
}

// Subclass
- (void)dataSourceDidLoad {
  [self updateState];
}

#pragma mark CardStateMachine
/**
 If dataIsAvailable and !dataIsLoading and dataSourceIsReady, remove empty/loading screens
 If !dataIsAvailable and !dataIsLoading and dataSourceIsReady, show empty screen
 If dataIsLoading and !dataSourceIsReady, show loading screen
 If !dataIsLoading and !dataSourceIsReady, show empty/error screen
 */
//- (BOOL)dataIsAvailable;
//- (BOOL)dataIsLoading;
//- (BOOL)dataSourceIsReady;
//- (void)updateState;

- (BOOL)dataSourceIsReady {
  return NO;
}

- (BOOL)dataIsAvailable {
  return NO;
}

- (BOOL)dataIsLoading {
  return NO;
}

- (void)updateState {
  if ([self dataSourceIsReady]) {
    // Data Source finished loading from remote and is ready to display
    // We should never be in a loading state here
    if ([self dataIsAvailable]) {
      // We have real data to display
      self.emptyView.hidden = YES;
      [self hideLoadingView];
    } else {
      // We have no data to display, show the empty screen
      self.emptyView.hidden = NO;
      [self hideLoadingView];
    }
  } else {
    // Data source isn't done loading from remote
    // For now we will just always show a loading screen in this case
    [self showLoadingView];
  }
}

- (void)showLoadingView {
  [self.view bringSubviewToFront:self.loadingView];
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3];
  self.loadingView.frame = CGRectMake(0, 0, self.loadingView.width, self.loadingView.height);
  [UIView commitAnimations];
}

- (void)hideLoadingView {
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3];
  self.loadingView.frame = CGRectMake(0, self.view.height, self.loadingView.width, self.loadingView.height);
  [UIView commitAnimations];
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
  DLog(@"nav will show controller: %@", [viewController class]);
  if ([viewController isKindOfClass:[PlaceViewController class]]) {
    APP_DELEGATE.launcherViewController.scrollView.scrollEnabled = NO;
  } else {
    APP_DELEGATE.launcherViewController.scrollView.scrollEnabled = YES;
  }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
  DLog(@"nav did show controller: %@", [viewController class]);
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
  RELEASE_SAFELY(_emptyView);
  RELEASE_SAFELY(_emptyLabel);
  RELEASE_SAFELY(_loadingView);
  RELEASE_SAFELY(_loadingLabel);
  RELEASE_SAFELY(_loadingSpinner);
  [super dealloc];
}


@end
