//
//  PlaceViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardViewController.h"

@class CheckinHereViewController;
@class PlaceInfoViewController;
@class PlaceActivityViewController;
@class PlaceFeedViewController;

@interface PlaceViewController : CardViewController <UIScrollViewDelegate> {
  CheckinHereViewController *_checkinHereViewController;
  PlaceInfoViewController *_placeInfoViewController;
  PlaceActivityViewController *_placeActivityViewController;
  PlaceFeedViewController *_placeFeedViewController;
  
  id _visibleViewController;
  
  // Params
  NSString *_placeId;
  NSString *_placeName;
  BOOL _shouldShowCheckinHere;
  
  // UI
  UIBarButtonItem *_checkinHereButton;
  UIScrollView *_placeScrollView;
  UIView *_tabView;
  UIButton *_infoButton;
  UIButton *_activityButton;
  UIButton *_feedButton;
}

@property (nonatomic, retain) NSString *placeId;
@property (nonatomic, retain) NSString *placeName;
@property (nonatomic, assign) BOOL shouldShowCheckinHere;

@end
