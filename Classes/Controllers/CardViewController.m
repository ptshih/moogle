    //
//  CardViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CardViewController.h"
#import "Constants.h"

#import "PlaceTabViewController.h"
#import "WhoViewController.h"

@interface CardViewController (Private)

- (void)showLoadingView;
- (void)hideLoadingView;

@end

@implementation CardViewController

@synthesize emptyView = _emptyView;
@synthesize loadingView = _loadingView;

- (id)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
  self.view.frame = CGRectMake(0, 0, kCardWidth, kCardHeight - 44.0);
  self.view.clipsToBounds = YES;
  
  // Setup Empty and Loading View
  if ([self isKindOfClass:[PlaceTabViewController class]]) {
    [[NSBundle mainBundle] loadNibNamed:@"EmptyPlaceView" owner:self options:nil];
    [[NSBundle mainBundle] loadNibNamed:@"LoadingPlaceView" owner:self options:nil];
  } else if ([self isKindOfClass:[WhoViewController class]]) {
  } else {
    [[NSBundle mainBundle] loadNibNamed:@"EmptyView" owner:self options:nil];
    [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil];
  }
  
  self.emptyView.hidden = YES;
  self.loadingView.frame = CGRectMake(0, 0, self.loadingView.width, self.loadingView.height);
  [self.view addSubview:self.emptyView];
  [self.view addSubview:self.loadingView];
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
  RELEASE_SAFELY(_loadingView);
  [super dealloc];
}


@end
