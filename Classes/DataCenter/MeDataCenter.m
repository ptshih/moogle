//
//  MeDataCenter.m
//  Moogle
//
//  Created by Peter Shih on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MeDataCenter.h"

@interface MeDataCenter (Private)

- (void)kupoRequestDidFinish:(ASIHTTPRequest *)request;

@end

@implementation MeDataCenter

@synthesize responseArray = _responseArray;

- (void)requestFinished:(ASIHTTPRequest *)request {
  DLog(@"Request Finished with Status Code: %d, : %@", [request responseStatusCode], request);
  // This is on the main thread
  NSInteger statusCode = [request responseStatusCode];
  if(statusCode > 200) {
    [self dataCenterFailedWithRequest:request];
  } else {
    // Successful request
    [self kupoRequestDidFinish:request];
  }
}

- (void)kupoRequestDidFinish:(ASIHTTPRequest *)request {
  DLog(@"Me request finished with response: %@", [request responseString])
  
  [self dataCenterFinishedWithRequest:request];
}

- (void)dealloc {
  RELEASE_SAFELY(_responseArray);
  [super dealloc];
}

@end
