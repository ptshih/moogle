//
//  NearbyViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTableViewController.h"

@class ASIHTTPRequest;

@interface NearbyViewController : CardTableViewController{
  ASIHTTPRequest *_nearbyRequest;
}

@property (nonatomic, retain) ASIHTTPRequest *nearbyRequest;

- (void)getNearbyPlaces;

@end
