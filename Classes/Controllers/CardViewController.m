    //
//  CardViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CardViewController.h"
#import "PlaceViewController.h"
#import "Constants.h"

@interface CardViewController (Private)

- (void)setupFilterButtons;
- (void)animateShowFilter;
- (void)animateHideFilter;

@end

@implementation CardViewController

@synthesize filterView = _filterView;

- (id)init {
  self = [super init];
  if (self) {
    _filterView = [[UIView alloc] init];
    _isFiltering = NO;
  }
  return self;
}

- (void)loadView {
  [super loadView];
  self.view.frame = CGRectMake(0, 0, kCardWidth, kCardHeight - 44.0);
  self.view.clipsToBounds = YES;
  
  // Setup Filter View
  self.filterView.frame = CGRectMake(0, -44.0, 320.0, 44.0);
  self.filterView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"filter_gradient.png"]];
  
  [self.view addSubview:self.filterView];
  
  [self setupFilterButtons];
}

- (void)setupFilterButtons {
  UIButton *categoryButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 8, 100, 29)];
  UIButton *distanceButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 8, 100, 29)];
  UIButton *whoButton = [[UIButton alloc] initWithFrame:CGRectMake(215, 8, 100, 29)];
  [categoryButton setBackgroundImage:[UIImage imageNamed:@"btn_filter.png"] forState:UIControlStateNormal];
  [categoryButton setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected.png"] forState:UIControlStateHighlighted];
  [distanceButton setBackgroundImage:[UIImage imageNamed:@"btn_filter.png"] forState:UIControlStateNormal];
  [distanceButton setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected.png"] forState:UIControlStateHighlighted];
  [whoButton setBackgroundImage:[UIImage imageNamed:@"btn_filter.png"] forState:UIControlStateNormal];
  [whoButton setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected.png"] forState:UIControlStateHighlighted];
  
  [categoryButton setTitle:@"Category" forState:UIControlStateNormal];
  [categoryButton setTitleColor:FILTER_COLOR_BLUE forState:UIControlStateNormal];
  categoryButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
  categoryButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
  
  [distanceButton setTitle:@"Distance" forState:UIControlStateNormal];
  [distanceButton setTitleColor:FILTER_COLOR_BLUE forState:UIControlStateNormal];
  distanceButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
  distanceButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
  
  [whoButton setTitle:@"Who" forState:UIControlStateNormal];
  [whoButton setTitleColor:FILTER_COLOR_BLUE forState:UIControlStateNormal];
  whoButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
  whoButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
  
  [self.filterView addSubview:categoryButton];
  [self.filterView addSubview:distanceButton];
  [self.filterView addSubview:whoButton];
  
  [categoryButton release];
  [distanceButton release];
  [whoButton release];
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

- (void)filter {
  if (_isFiltering) {
    // Hide filter drop-down
    _isFiltering = NO;
    [self animateHideFilter];
  } else {
    // Show filter drop-down
    _isFiltering = YES;
    [self animateShowFilter];
  }
}

- (void)showPlaceWithId:(NSNumber *)placeId {
  PlaceViewController *pvc = [[PlaceViewController alloc] initWithNibName:@"PlaceViewController" bundle:nil];
  pvc.placeId = placeId;
  [self.navigationController pushViewController:pvc animated:YES];
  [pvc release];  
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
  RELEASE_SAFELY (_filterView);
  [super dealloc];
}


@end
