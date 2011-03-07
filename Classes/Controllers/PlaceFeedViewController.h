//
//  PlaceFeedViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceTabViewController.h"

@interface PlaceFeedViewController : PlaceTabViewController {
  ASIHTTPRequest *_placeFeedRequest;    
}

- (void)getPlaceFeed;

@end
