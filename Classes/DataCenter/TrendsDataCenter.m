//
//  TrendsDataCenter.m
//  Moogle
//
//  Created by Peter Shih on 2/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TrendsDataCenter.h"

@implementation TrendsDataCenter
  
- (id)init {
  self = [super init];
  if (self) {
    _responseKeys = [[NSArray arrayWithObjects:@"place_id", @"place_name", @"checkins_count", @"like_count", @"checkins_friend_count", @"distance", nil] retain];
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
