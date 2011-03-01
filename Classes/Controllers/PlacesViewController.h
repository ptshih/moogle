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

@class PlacesDataCenter;
@class ASIHTTPRequest;

@interface PlacesViewController : CardTableViewController <MoogleDataCenterDelegate> {
  PlacesDataCenter *_dataCenter;
  ASIHTTPRequest *_nearbyRequest;
}

@property (nonatomic, retain) PlacesDataCenter *dataCenter;
@property (nonatomic, retain) ASIHTTPRequest *nearbyRequest;

- (void)getNearbyPlaces;

@end
