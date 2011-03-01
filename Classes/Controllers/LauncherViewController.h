//
//  LauncherViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class MeViewController;
@class NearbyViewController;
@class CheckinsViewController;

@interface LauncherViewController : UIViewController {
  IBOutlet UIScrollView *_scrollView;
  IBOutlet UIPageControl *_pageControl;
  IBOutlet UILabel *_placeLabel;
  
  // Cards
  MeViewController *_meViewController;
  NearbyViewController *_nearbyViewController;
  CheckinsViewController *_checkinsViewController;
  
  NSArray *_cards;
  
  BOOL _isZoomed;
  NSInteger _previousPage;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) UILabel *placeLabel;

// Cards
@property (nonatomic, retain) MeViewController *meViewController;
@property (nonatomic, retain) NearbyViewController *nearbyViewController;
@property (nonatomic, retain) CheckinsViewController *checkinsViewController;

@property (nonatomic, retain) NSArray *cards;

- (void)reloadVisibleCard;
- (void)clearAllCachedData;

@end
