//
//  LauncherViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearbyPlacesDelegate.h"

@class CheckinsViewController;
@class NearbyPlacesViewController;
@class TrendsViewController;

@interface LauncherViewController : UIViewController <NearbyPlacesDelegate> {
  IBOutlet UIScrollView *_scrollView;
  IBOutlet UIPageControl *_pageControl;
  
  // Cards
  CheckinsViewController *_checkinsViewController;
  NearbyPlacesViewController *_nearbyPlacesViewController;
  TrendsViewController *_trendsViewController;
  
  NSArray *_cards;
  NSInteger _currentPage;
  
  BOOL _isZoomed;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;

// Cards
@property (nonatomic, retain) CheckinsViewController *checkinsViewController;
@property (nonatomic, retain) NearbyPlacesViewController *nearbyPlacesViewController;
@property (nonatomic, retain) TrendsViewController *trendsViewController;

@property (nonatomic, retain) NSArray *cards;

- (void)reloadCheckins;

@end
