//
//  PlacesDataCenter.m
//  Moogle
//
//  Created by Peter Shih on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlacesDataCenter.h"

@interface PlacesDataCenter (Private)

- (void)checkinHereRequestDidFinish:(ASIHTTPRequest *)request;
- (void)placeRequestDidFinish:(ASIHTTPRequest *)request;

@end

@implementation PlacesDataCenter

@synthesize checkinHereRequest = _checkinHereRequest;
@synthesize placeRequest = _placeRequest;

- (void)requestFinished:(ASIHTTPRequest *)request {
  DLog(@"Request Finished with Status Code: %d, : %@", [request responseStatusCode], request);
  // This is on the main thread
  NSInteger statusCode = [request responseStatusCode];
  if(statusCode > 200) {
  } else {
    // Successful request
    if ([request isEqual:self.checkinHereRequest]) {
      // This is a post to facebook checkin request
      [self checkinHereRequestDidFinish:request];
    } else if ([request isEqual:self.placeRequest]) {
      // This is a get request from moogle for place info
      [self placeRequestDidFinish:request];
    }
  }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
  DLog(@"Request Failed with Error: %@", [request error]);
}

- (void)checkinHereRequestDidFinish:(ASIHTTPRequest *)request {
  DLog(@"Successfully posted a checkin to facebook with response: %@", [request responseString]);
  
  // Inform delegate the operation Finished
  if (self.delegate) {
    [self.delegate retain];
    if ([self.delegate respondsToSelector:@selector(dataCenterDidFinish:)]) {
      [self.delegate performSelector:@selector(dataCenterDidFinish:) withObject:request];
    }
    [self.delegate release];
  }
}

- (void)placeRequestDidFinish:(ASIHTTPRequest *)request {
  DLog(@"Successfully got place with response: %@", [request responseString]);
  
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
