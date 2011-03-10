//
//  NearbyPickerViewController.h
//  Moogle
//
//  Created by Peter Shih on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardPlacesTableViewController.h"
#import "NearbyPickerDelegate.h"


@interface NearbyPickerViewController : CardPlacesTableViewController {
  ASIHTTPRequest *_nearbyRequest;
  
  id <NearbyPickerDelegate> _delegate;
}

@property (nonatomic, retain) ASIHTTPRequest *nearbyRequest;

@property (nonatomic, assign) id <NearbyPickerDelegate> delegate;

@end
