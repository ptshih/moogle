/*
 *  NearbyPlacesDelegate.h
 *  Moogle
 *
 *  Created by Peter Shih on 2/8/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

@protocol NearbyPlacesDelegate <NSObject>
@optional
- (void)tappedPlaceWithId:(NSNumber *)placeId;
@end