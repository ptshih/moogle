//
//  PlacesViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardPlacesTableViewController.h"

@interface PlacesViewController : CardPlacesTableViewController {
  ASIHTTPRequest *_nearbyRequest;
}

@property (nonatomic, retain) ASIHTTPRequest *nearbyRequest;

- (void)getNearbyPlaces;

@end
