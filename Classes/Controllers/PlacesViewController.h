//
//  PlacesViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTableViewController.h"
#import "MoogleDataCenterDelegate.h"

enum {
  PlacesTypeNearby = 0,
  PlacesTypeTrends = 1
};
typedef uint32_t PlacesType;

@class PlacesDataCenter;
@class TrendsDataCenter;
@class ASIHTTPRequest;

@interface PlacesViewController : CardTableViewController <MoogleDataCenterDelegate> {
  PlacesDataCenter *_dataCenter;
  TrendsDataCenter *_trendsDataCenter;
  ASIHTTPRequest *_nearbyRequest;
  ASIHTTPRequest *_trendsRequest;
  
  PlacesType _placesMode;
}

@property (nonatomic, retain) PlacesDataCenter *dataCenter;
@property (nonatomic, retain) TrendsDataCenter *trendsDataCenter;
@property (nonatomic, retain) ASIHTTPRequest *nearbyRequest;
@property (nonatomic, retain) ASIHTTPRequest *trendsRequest;

- (void)getNearbyPlaces;
- (void)getTrends;

@end
