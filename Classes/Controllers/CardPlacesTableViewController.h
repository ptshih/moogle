//
//  CardPlaceTableViewController.h
//  Moogle
//
//  Created by Peter Shih on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTableViewController.h"
#import "MoogleDataCenterDelegate.h"
#import "PlacesDataCenter.h"
#import "PlaceViewController.h"
#import "LocationManager.h"
#import "PlaceCell.h"
#import "Place.h"

@interface CardPlacesTableViewController : CardTableViewController <UIActionSheetDelegate, MoogleDataCenterDelegate> {
  PlacesDataCenter *_dataCenter;
  NSString *_distance;
  UIBarButtonItem *_distanceButton;
}

@property (nonatomic, retain) PlacesDataCenter *dataCenter;

- (void)setupDistanceButton;
- (void)showPlaceForPlace:(Place *)place;

@end
