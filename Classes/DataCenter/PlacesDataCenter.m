//
//  PlacesDataCenter.m
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlacesDataCenter.h"

@implementation PlacesDataCenter
  
- (id)init {
  self = [super init];
  if (self) {
    _responseKeys = [[NSArray arrayWithObjects:@"place_id", @"place_name", @"checkins_count", @"checkins_friend_count", @"like_count", @"distance", nil] retain];
  }
  return self;
}

#pragma MoogleDataCenter Implementations
- (void)dataCenterFinishedWithRequest:(ASIHTTPRequest *)request {  
  // Tell MoogleDataCenter to inform delegate
  [super dataCenterFinishedWithRequest:request];
}

- (void)dataCenterFailedWithRequest:(ASIHTTPRequest *)request {
  
  // Tell MoogleDataCenter to inform delegate
  [super dataCenterFailedWithRequest:request];
}

- (void)dealloc {
  [super dealloc];
}
@end
