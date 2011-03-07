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
#import "MoogleDataCenter.h"

@interface PlaceTabViewController : CardTableViewController <MoogleDataCenterDelegate> {
  MoogleDataCenter *_dataCenter;
  Place *place;
}

@property (nonatomic, retain) MoogleDataCenter *dataCenter;
@property (nonatomic, assign) Place *place;

@end
