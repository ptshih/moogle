//
//  CardModalViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CardModalViewController.h"
#import "Constants.h"

@implementation CardModalViewController

@synthesize navigationBar = _navigationBar;
@synthesize dismissButtonTitle = _dismissButtonTitle;

- (id)init {
  self = [super init];
  if (self) {
    _navigationBar = [[UINavigationBar alloc] init];
    _dismissButtonTitle = @"Cancel";
    self.title = @"Moogle";
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationBar.frame = CGRectMake(0, 0, 320, 44);
  
  // Setup Nav Items and Done button
  UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:self.title];
  UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:self.dismissButtonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
  navItem.rightBarButtonItem = dismissButton;
  [dismissButton release];
  [self.navigationBar setItems:[NSArray arrayWithObject:navItem]];
  [navItem release];
  
  [self.view addSubview:self.navigationBar];
  
  self.navigationBar.tintColor = MOOGLE_BLUE_COLOR;
}

- (void)dismiss {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
  RELEASE_SAFELY(_dismissButtonTitle);
  RELEASE_SAFELY(_navigationBar);
  [super dealloc];
}

@end
