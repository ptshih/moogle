//
//  FeedDataCenter.m
//  Moogle
//
//  Created by Peter Shih on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FeedDataCenter.h"

@implementation FeedDataCenter

- (id)init {
  self = [super init];
  if (self) {
    _responseKeys = [[NSArray arrayWithObjects:@"checkin_id", @"facebook_id", @"name", @"place_id", @"place_name", @"message", @"checkin_timestamp", @"tagged_count", @"tagged_user_Array", nil] retain];
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
