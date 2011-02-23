//
//  CheckinsDataCenter.m
//  Moogle
//
//  Created by Peter Shih on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CheckinsDataCenter.h"

@interface CheckinsDataCenter (Private)

- (void)checkinsRequestDidFinish:(ASIHTTPRequest *)request;

@end

@implementation CheckinsDataCenter

@synthesize checkinsRequest = _checkinsRequest;

- (void)requestFinished:(ASIHTTPRequest *)request {
  DLog(@"Request Finished with Status Code: %d, : %@", [request responseStatusCode], request);
  // This is on the main thread
  NSInteger statusCode = [request responseStatusCode];
  if(statusCode > 200) {
  } else {
    // Successful request
    if ([request isEqual:self.checkinsRequest]) {
      // This is a get from moogle for a list of checkins
      [self checkinsRequestDidFinish:request];
    }
  }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
  DLog(@"Request Failed with Error: %@", [request error]);
}

- (void)checkinsRequestDidFinish:(ASIHTTPRequest *)request {
  DLog(@"Successfully got a list of checkins with response: %@", [request responseString]);
  
  // Inform delegate the operation Finished
  if (self.delegate) {
    [self.delegate retain];
    if ([self.delegate respondsToSelector:@selector(dataCenterDidFinish:)]) {
      [self.delegate performSelector:@selector(dataCenterDidFinish:) withObject:request];
    }
    [self.delegate release];
  }
}

@end
