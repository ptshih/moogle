//
//  NearbyPickerViewController.h
//  Moogle
//
//  Created by Peter Shih on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTableViewController.h"
#import "NearbyPickerDelegate.h"
#import "MoogleDataCenterDelegate.h"

@class PlacesDataCenter;

@interface NearbyPickerViewController : CardTableViewController <MoogleDataCenterDelegate> {
  PlacesDataCenter *_dataCenter;
  ASIHTTPRequest *_nearbyRequest;
  
  id <NearbyPickerDelegate> _delegate;
}

@property (nonatomic, retain) PlacesDataCenter *dataCenter;
@property (nonatomic, retain) ASIHTTPRequest *nearbyRequest;

@property (nonatomic, assign) id <NearbyPickerDelegate> delegate;

@end
