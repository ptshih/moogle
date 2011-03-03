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
@class MeViewController;
@class PlacesViewController;
@class CheckinsViewController;

@interface LauncherViewController : UIViewController {
  IBOutlet UIScrollView *_scrollView;
  IBOutlet CardTabBar *_cardTabBar;
  
  // Cards
  MeViewController *_meViewController;
  PlacesViewController *_placesViewController;;
  CheckinsViewController *_checkinsViewController;
  
  NSArray *_cards;
  
  BOOL _isZoomed;
  NSInteger _currentPage;
  NSInteger _previousPage;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) CardTabBar *cardTabBar;

// Cards
@property (nonatomic, retain) MeViewController *meViewController;
@property (nonatomic, retain) PlacesViewController *placesViewController;
@property (nonatomic, retain) CheckinsViewController *checkinsViewController;

@property (nonatomic, retain) NSArray *cards;

- (void)reloadVisibleCard;
- (void)clearAllCachedData;

@end
