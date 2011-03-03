//
//  PlaceInfoViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceTabViewController.h"

@interface PlaceInfoViewController : PlaceTabViewController {
  ASIHTTPRequest *_placeInfoRequest;
  UIImage *_placeImage;
}

@property (nonatomic, retain) ASIHTTPRequest *placeInfoRequest;

- (void)getPlaceInfo;

@end
