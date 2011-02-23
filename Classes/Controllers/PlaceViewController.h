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

@class ASIHTTPRequest;
@class MoogleDataCenter;

@interface PlaceViewController : CardViewController <MoogleDataCenterDelegate> {
  // Params
  NSNumber *_placeId;
  
  ASIHTTPRequest *_placeRequest;
  MoogleDataCenter *_dataCenter;
  
  // UI
  UILabel *_totalLabel;
  UILabel *_friendsLabel;
  UILabel *_likesLabel;
}

@property (nonatomic, retain) NSNumber *placeId;

@property (nonatomic, retain) ASIHTTPRequest *placeRequest;
@property (nonatomic, retain) MoogleDataCenter *dataCenter;

@end
