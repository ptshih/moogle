//
//  DiscoverViewController.h
//  Moogle
//
//  Created by Peter Shih on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardPlacesTableViewController.h"

@interface DiscoverViewController : CardPlacesTableViewController {
  ASIHTTPRequest *_discoverRequest;
}

@property (nonatomic, retain) ASIHTTPRequest *discoverRequest;

- (void)getDiscovers;

@end
