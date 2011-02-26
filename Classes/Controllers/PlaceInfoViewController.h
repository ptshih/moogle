//
//  PlaceInfoViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTableViewController.h"
#import "MoogleDataCenterDelegate.h"

@class PlacesDataCenter;
@class ASIHTTPRequest;

@interface PlaceInfoViewController : CardTableViewController <MoogleDataCenterDelegate> {
  PlacesDataCenter *_dataCenter;
  NSNumber *_placeId;
  ASIHTTPRequest *_placeInfoRequest;
}

@property (nonatomic, retain) PlacesDataCenter *dataCenter;
@property (nonatomic, retain) NSNumber *placeId;
@property (nonatomic, retain) ASIHTTPRequest *placeInfoRequest;

- (void)getPlace;

@end
