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
@class PlacesViewController;
@class CheckinsViewController;
@class TrendsViewController;

@interface LauncherViewController : UIViewController {
  IBOutlet UIScrollView *_scrollView;
  IBOutlet UIPageControl *_pageControl;
  IBOutlet UILabel *_placeLabel;
  
  // Cards
  MeViewController *_meViewController;
  PlacesViewController *_placesViewController;;
  CheckinsViewController *_checkinsViewController;
  TrendsViewController *_trendsViewController;
  
  NSArray *_cards;
  
  BOOL _isZoomed;
  NSInteger _previousPage;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) UILabel *placeLabel;

// Cards
@property (nonatomic, retain) MeViewController *meViewController;
@property (nonatomic, retain) PlacesViewController *placesViewController;
@property (nonatomic, retain) CheckinsViewController *checkinsViewController;
@property (nonatomic, retain) TrendsViewController *trendsViewController;

@property (nonatomic, retain) NSArray *cards;

- (void)reloadVisibleCard;
- (void)clearAllCachedData;

@end
