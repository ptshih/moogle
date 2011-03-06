//
//  DiscoverViewController.h
//  Moogle
//
//  Created by Peter Shih on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTableViewController.h"
#import "MoogleDataCenterDelegate.h"

@class PlacesDataCenter;

@interface DiscoverViewController : CardTableViewController <MoogleDataCenterDelegate> {
  PlacesDataCenter *_dataCenter;
  ASIHTTPRequest *_discoverRequest;
}

@property (nonatomic, retain) PlacesDataCenter *dataCenter;
@property (nonatomic, retain) ASIHTTPRequest *discoverRequest;

- (void)getDiscovers;

@end
