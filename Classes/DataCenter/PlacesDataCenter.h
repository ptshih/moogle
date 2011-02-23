//
//  PlacesDataCenter.h
//  Moogle
//
//  Created by Peter Shih on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoogleDataCenter.h"

@interface PlacesDataCenter : MoogleDataCenter {
  ASIHTTPRequest *_checkinHereRequest;
  ASIHTTPRequest *_placeRequest;
}

@property (nonatomic, assign) ASIHTTPRequest *checkinHereRequest;
@property (nonatomic, assign) ASIHTTPRequest *placeRequest;

@end
