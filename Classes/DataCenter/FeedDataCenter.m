//
//  FeedDataCenter.m
//  Moogle
//
//  Created by Peter Shih on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FeedDataCenter.h"
#import "Checkin.h"

@implementation FeedDataCenter

@synthesize checkinsArray = _checkinsArray;

- (id)init {
  self = [super init];
  if (self) {
    _checkinsArray = [[NSMutableArray alloc] init];
  }
  return self;
}

#pragma MoogleDataCenter Implementations
- (void)dataCenterFinishedWithRequest:(ASIHTTPRequest *)request {
  if (self.checkinsArray) {
    [self.checkinsArray removeAllObjects];
  }
  
  // Serialize all the checkins in the array
  for (NSDictionary *checkinDict in self.response) {
    Checkin *newCheckin = [[Checkin alloc] initWithDictionary:checkinDict];
    [self.checkinsArray addObject:newCheckin];
    [newCheckin release];
  }
  
  // Tell MoogleDataCenter to inform delegate
  [super dataCenterFinishedWithRequest:request];
}

- (void)dataCenterFailedWithRequest:(ASIHTTPRequest *)request {
  
  // Tell MoogleDataCenter to inform delegate
  [super dataCenterFailedWithRequest:request];
}

- (void)dealloc {
  RELEASE_SAFELY(_checkinsArray);
  [super dealloc];
}

@end
