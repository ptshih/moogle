//
//  MoogleDataCenter.m
//  Moogle
//
//  Created by Peter Shih on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MoogleDataCenter.h"

@interface MoogleDataCenter (Private)

- (void)moogleRequestDidFinish:(ASIHTTPRequest *)request;

@end

@implementation MoogleDataCenter

@synthesize delegate = _delegate;
@synthesize parsedResponse = _parsedResponse;

#pragma mark ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
  DLog(@"Request Finished with Status Code: %d, : %@", [request responseStatusCode], request);
  // This is on the main thread
  NSInteger statusCode = [request responseStatusCode];
  if(statusCode > 200) {
  } else {
    [self moogleRequestDidFinish:request];
  }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
  DLog(@"Request Failed with Error: %@", [request error]);
}

- (void)moogleRequestDidFinish:(ASIHTTPRequest *)request {
  DLog(@"Successfully got a list of checkins with response: %@", [request responseString]);
  
  _parsedResponse = [[[CJSONDeserializer deserializer] deserialize:[request responseData] error:nil] retain];
  
  // Inform delegate the operation Finished
  if (self.delegate) {
    [self.delegate retain];
    if ([self.delegate respondsToSelector:@selector(dataCenterDidFinish:)]) {
      [self.delegate performSelector:@selector(dataCenterDidFinish:) withObject:request];
    }
    [self.delegate release];
  }
}

- (void)dealloc {
  RELEASE_SAFELY (_parsedResponse);
  [super dealloc];
}

@end
