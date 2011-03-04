//
//  MeDataCenter.m
//  Moogle
//
//  Created by Peter Shih on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MeDataCenter.h"

@implementation MeDataCenter

- (id)init {
  self = [super init];
  if (self) {
//    _responseKeys = [[NSArray arrayWithObjects:@"place_id", @"place_name", @"checkin_time", @"user_facebook_id", @"user_name", @"your_last_checkin_time", @"your_facebook_id", nil] retain];
    
    _responseKeys = [[NSArray arrayWithObjects:@"facebook_id", @"you_last_checkin_time", @"you_last_checkin_place_name", @"you_last_checkin_place_id", @"total_checkins", @"total_authored", @"total_you_tagged", @"total_tagged_you", @"you_total_unique_places", @"you_friend_total_unique_places", @"friend_tagged_you_array", @"you_tagged_friend_array", @"you_top_places_array", @"you_friends_top_places_array", nil] retain];
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
