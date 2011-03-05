//
//  PlaceTabViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTableViewController.h"
#import "LocationManager.h"
#import "Place.h"
#import "MoogleDataCenterDelegate.h"
#import "PlaceDataCenter.h"

@interface PlaceTabViewController : CardTableViewController <MoogleDataCenterDelegate> {
  PlaceDataCenter *_dataCenter;
  Place *place;
  CGRect viewport; // NOTE: this is totally a hack around the view init hierarchy
}

@property (nonatomic, retain) PlaceDataCenter *dataCenter;
@property (nonatomic, assign) Place *place;
@property (nonatomic, assign) CGRect viewport;

@end
