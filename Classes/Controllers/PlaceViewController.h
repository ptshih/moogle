//
//  PlaceViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardViewController.h"
#import "MoogleDataCenterDelegate.h"

@class PlaceDataCenter;
@class Place;
@class PlaceInfoViewController;
@class PlaceActivityViewController;
@class PlaceFeedViewController;
@class PlaceReviewsViewController;

@interface PlaceViewController : CardViewController <MoogleDataCenterDelegate, UIScrollViewDelegate> {
  PlaceInfoViewController *_placeInfoViewController;
  PlaceActivityViewController *_placeActivityViewController;
  PlaceFeedViewController *_placeFeedViewController;
  PlaceReviewsViewController *_placeReviewsViewController;
  
  id _visibleViewController;
  
  // Network
  PlaceDataCenter *_dataCenter;
  ASIHTTPRequest *_placeRequest;
  Place *place;
  
  // UI
  UIBarButtonItem *_checkinHereButton;
  UIScrollView *_placeScrollView;
  UIView *_tabView;
  UIButton *_infoButton;
  UIButton *_activityButton;
  UIButton *_feedButton;
  UIButton *_reviewsButton;
}

@property (nonatomic, retain) PlaceDataCenter *dataCenter;
@property (nonatomic, retain) Place *place;

- (void)reloadInfo;

@end
