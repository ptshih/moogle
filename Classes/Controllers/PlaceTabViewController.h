//
//  PlaceTabViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTableViewController.h"
#import "MoogleDataCenterDelegate.h"

#import "LocationManager.h"
#import "PlaceDataCenter.h"

@class PlaceDataCenter;

@interface PlaceTabViewController : CardTableViewController <MoogleDataCenterDelegate> {
  PlaceDataCenter *_dataCenter;
  NSString *_placeId;
  CGRect viewport; // NOTE: this is totally a hack around the view init hierarchy
}

@property (nonatomic, retain) PlaceDataCenter *dataCenter;
@property (nonatomic, retain) NSString *placeId;
@property (nonatomic, assign) CGRect viewport;

- (void)reloadDataSource;

@end
