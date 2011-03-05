//
//  PlacesDataCenter.m
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlacesDataCenter.h"
#import "Place.h"

@implementation PlacesDataCenter
  
@synthesize placesArray = _placesArray;

- (id)init {
  self = [super init];
  if (self) {
    _placesArray = [[NSMutableArray alloc] init];
  }
  return self;
}

#pragma MoogleDataCenter Implementations
- (void)dataCenterFinishedWithRequest:(ASIHTTPRequest *)request {  
  if (self.placesArray) {
    [self.placesArray removeAllObjects];
  }
  // Serialize all the places in the array
  for (NSDictionary *placeDict in self.response) {
    Place *newPlace = [[Place alloc] initWithDictionary:placeDict];
    [self.placesArray addObject:newPlace];
    [newPlace release];
  }
  
  // Tell MoogleDataCenter to inform delegate
  [super dataCenterFinishedWithRequest:request];
}

- (void)dataCenterFailedWithRequest:(ASIHTTPRequest *)request {
  
  // Tell MoogleDataCenter to inform delegate
  [super dataCenterFailedWithRequest:request];
}

- (void)dealloc {
  RELEASE_SAFELY(_placesArray);
  [super dealloc];
}
@end
