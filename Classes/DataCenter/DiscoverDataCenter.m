//
//  DiscoverDataCenter.m
//  Moogle
//
//  Created by Peter Shih on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DiscoverDataCenter.h"


@implementation DiscoverDataCenter

- (id)init {
  self = [super init];
  if (self) {
    _responseKeys = [[NSArray arrayWithObjects:@"facebook_id", @"name", @"place_id", @"place_name", @"message", nil] retain];
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
