//
//  NearbyPickerDelegate.h
//  Moogle
//
//  Created by Peter Shih on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.h"

@protocol NearbyPickerDelegate <NSObject>
@optional
- (void)nearbyPickedWithPlace:(Place *)place;

@end
