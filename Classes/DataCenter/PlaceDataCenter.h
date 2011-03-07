//
//  PlaceDataCenter.h
//  Moogle
//
//  Created by Peter Shih on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoogleDataCenter.h"

@class Place;

@interface PlaceDataCenter : MoogleDataCenter {
  Place *_place;
}

@property (nonatomic, retain) Place *place;

@end
