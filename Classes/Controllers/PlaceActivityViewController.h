//
//  PlaceActivityViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceTabViewController.h"

@interface PlaceActivityViewController : PlaceTabViewController {
  ASIHTTPRequest *_placeActivityRequest;    
}

@property (nonatomic, retain) ASIHTTPRequest *placeActivityRequest;

- (void)getPlaceActivity;

@end
