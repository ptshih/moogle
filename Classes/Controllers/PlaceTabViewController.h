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
#import "Constants.h"
#import "LocationManager.h"
#import "PlacesDataCenter.h"

#import "ASIHTTPRequest.h"
#import "RemoteRequest.h"
#import "RemoteOperation.h"

@class PlacesDataCenter;

@interface PlaceTabViewController : CardTableViewController <MoogleDataCenterDelegate> {
  PlacesDataCenter *_dataCenter;
  NSNumber *_placeId;
}

@property (nonatomic, retain) PlacesDataCenter *dataCenter;
@property (nonatomic, retain) NSNumber *placeId;

- (void)reloadDataSource;

@end
