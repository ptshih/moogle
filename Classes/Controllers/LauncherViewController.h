//
//  LauncherViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class CardTabBar;
@class CheckinsViewController;
@class PlacesViewController;
@class DiscoverViewController;
@class MeViewController;

@interface LauncherViewController : UIViewController <UITabBarDelegate> {
  IBOutlet UIScrollView *_scrollView;
  IBOutlet CardTabBar *_cardTabBar;
  
  // Cards
  CheckinsViewController *_checkinsViewController;
  PlacesViewController *_placesViewController;
  DiscoverViewController *_discoverViewController;
  MeViewController *_meViewController;

  
  NSArray *_cards;
  
  NSInteger _currentPage;
  NSInteger _previousPage;
  
  BOOL _isQuickScroll;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) CardTabBar *cardTabBar;

// Cards

@property (nonatomic, retain) CheckinsViewController *checkinsViewController;
@property (nonatomic, retain) PlacesViewController *placesViewController;
@property (nonatomic, retain) DiscoverViewController *discoverViewController;
@property (nonatomic, retain) MeViewController *meViewController;

@property (nonatomic, retain) NSArray *cards;

- (void)reloadVisibleCard;
- (void)clearAllCachedData;

@end
