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

@interface PlaceViewController : CardViewController {
  CheckinHereViewController *_checkinHereViewController;
  PlaceInfoViewController *_placeInfoViewController;
  
  id _visibleViewController;
  
  // Params
  NSNumber *_placeId;
  NSString *_placeName;
  BOOL _shouldShowCheckinHere;
  
  // UI
  UIButton *_checkinHereButton;
  UIView *_tabView;
  UIButton *_infoButton;
  UIButton *_activityButton;
  UIButton *_reviewsButton;
  UIView *_placeView;
}

@property (nonatomic, retain) NSNumber *placeId;
@property (nonatomic, retain) NSString *placeName;
@property (nonatomic, assign) BOOL shouldShowCheckinHere;

@end
