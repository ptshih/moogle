//
//  LauncherViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LauncherViewController.h"
#import "Constants.h"
#import "MeViewController.h"
#import "FriendsViewController.h"
#import "PlacesViewController.h"

@interface LauncherViewController (Private)

- (void)setupTabs;

@end

@implementation LauncherViewController

@synthesize tabBarController = _tabBarController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _tabBarController = [[UITabBarController alloc] init];
    
    [self setupTabs];
  }
  return self;
}

- (void)setupTabs {
  MeViewController *meViewController = [[MeViewController alloc] initWithNibName:@"MeViewController" bundle:nil];
  FriendsViewController *friendsViewController = [[FriendsViewController alloc] initWithNibName:@"FriendsViewController" bundle:nil];
  PlacesViewController *placesViewController = [[PlacesViewController alloc] initWithNibName:@"PlacesViewController" bundle:nil];
  
  UINavigationController *meNavController = [[UINavigationController alloc] initWithRootViewController:meViewController];
  UINavigationController *friendsNavController = [[UINavigationController alloc] initWithRootViewController:friendsViewController];
  UINavigationController *placesNavController = [[UINavigationController alloc] initWithRootViewController:placesViewController];
  
  meNavController.navigationBar.tintColor = FB_COLOR_DARK_BLUE;
  friendsNavController.navigationBar.tintColor = FB_COLOR_DARK_BLUE;
  placesNavController.navigationBar.tintColor = FB_COLOR_DARK_BLUE;
  
  meNavController.title = @"Moogle";
  friendsNavController.title = @"Friends";
  placesNavController.title = @"Places";
  
  meViewController.navigationItem.title = @"Moogle Me";
  friendsViewController.navigationItem.title = @"Moogle Friends";
  placesViewController.navigationItem.title = @"Moogle Places";
  
  // Put the viewcontrollers into the tab bar controller
	self.tabBarController.viewControllers = [NSArray arrayWithObjects:meNavController, friendsNavController, placesNavController, nil];
  
  [meViewController release];
  [meNavController release];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.view addSubview:self.tabBarController.view];
}

//- (void)viewWillAppear:(BOOL)animated {
//  // Don't show anything unless logged in
//}

// Override to allow orientations other than the default portrait orientation.
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//  return UIInterfaceOrientationIsPortrait(interfaceOrientation);
//}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)dealloc {
  RELEASE_SAFELY(_tabBarController);
  [super dealloc];
}


@end
