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
@class PlacesDataCenter;
@class CheckinHereViewController;

@interface PlaceViewController : CardTableViewController <MoogleDataCenterDelegate> {
  CheckinHereViewController *_checkinHereViewController;
  
  // Params
  NSNumber *_placeId;
  NSString *_placeName;
  BOOL _shouldShowCheckinHere;
  
  ASIHTTPRequest *_placeRequest;
  PlacesDataCenter *_dataCenter;
  
  // UI
  UIButton *_checkinHereButton;
}

@property (nonatomic, retain) NSNumber *placeId;
@property (nonatomic, retain) NSString *placeName;
@property (nonatomic, assign) BOOL shouldShowCheckinHere;

@property (nonatomic, retain) ASIHTTPRequest *placeRequest;
@property (nonatomic, retain) PlacesDataCenter *dataCenter;

@end
