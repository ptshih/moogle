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
