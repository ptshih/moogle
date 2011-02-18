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
@class FriendsViewController;

@interface LauncherViewController : UIViewController {
  IBOutlet UIScrollView *_scrollView;
  IBOutlet UIPageControl *_pageControl;
  
  // Cards
  MeViewController *_meViewController;
  NearbyViewController *_nearbyViewController;
  FriendsViewController *_friendsViewController;
  
  NSArray *_cards;
  
  BOOL _isZoomed;
  NSInteger _previousPage;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;

// Cards
@property (nonatomic, retain) MeViewController *meViewController;
@property (nonatomic, retain) NearbyViewController *nearbyViewController;
@property (nonatomic, retain) FriendsViewController *friendsViewController;

@property (nonatomic, retain) NSArray *cards;

- (void)reloadCheckins;
- (void)clearAllCachedData;

@end