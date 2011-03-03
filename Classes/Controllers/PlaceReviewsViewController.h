//
//  PlaceReviewsViewController.h
//  Moogle
//
//  Created by Peter Shih on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceTabViewController.h"

@interface PlaceReviewsViewController : PlaceTabViewController {
  ASIHTTPRequest *_placeReviewsRequest;    
}

@property (nonatomic, retain) ASIHTTPRequest *placeReviewsRequest;

- (void)getPlaceReviews;

@end
