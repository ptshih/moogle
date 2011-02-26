//
//  PlaceViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTableViewController.h"
#import "MoogleDataCenterDelegate.h"

@class ASIHTTPRequest;
@class MoogleDataCenter;
@class CheckinHereViewController;

@interface PlaceViewController : CardTableViewController <MoogleDataCenterDelegate> {
  CheckinHereViewController *_checkinHereViewController;
  
  // Params
  NSNumber *_placeId;
  BOOL _shouldShowCheckinHere;
  
  ASIHTTPRequest *_placeRequest;
  MoogleDataCenter *_dataCenter;
  
  // UI
  UIButton *_checkinHereButton;
}

@property (nonatomic, retain) NSNumber *placeId;
@property (nonatomic, assign) BOOL shouldShowCheckinHere;

@property (nonatomic, retain) ASIHTTPRequest *placeRequest;
@property (nonatomic, retain) MoogleDataCenter *dataCenter;

@end
