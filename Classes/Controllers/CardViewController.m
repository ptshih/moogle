    //
//  CardViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CardViewController.h"
#import "PlaceViewController.h"

@interface CardViewController (Private)

- (void)animateShowFilter;
- (void)animateHideFilter;

@end

@implementation CardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _isFiltering = NO;
  }
  return self;
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

// Called when this card controller comes into active view
// Subclasses should override this method
- (void)reloadCardController {
  
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
  [super dealloc];
}


@end
