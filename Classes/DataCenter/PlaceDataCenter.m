//
//  PlaceDataCenter.m
//  Moogle
//
//  Created by Peter Shih on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceDataCenter.h"
#import "CJSONDeserializer.h"
#import "Place.h"

@implementation PlaceDataCenter

@synthesize place = _place;

- (id)init {
  self = [super init];
  if (self) {
  }
  return self;
}

#pragma MoogleDataCenter Implementations
- (void)dataCenterFinishedWithRequest:(ASIHTTPRequest *)request {  
  if (self.place) {
    _place = nil;
  }
  
  // Serialize place
  _place = [[Place alloc] initWithDictionary:self.response];
  
  // Tell MoogleDataCenter to inform delegate
  [super dataCenterFinishedWithRequest:request];
}

- (void)dataCenterFailedWithRequest:(ASIHTTPRequest *)request {
  
  // Tell MoogleDataCenter to inform delegate
  [super dataCenterFailedWithRequest:request];
}

- (void)dealloc {
  RELEASE_SAFELY(_place);
  [super dealloc];
}

@end
