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
    [self dataCenterFailedWithRequest:request];
  } else {
    [self moogleRequestDidFinish:request];
  }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
  DLog(@"Data center Failed with Error: %@", [request error]);
  [self dataCenterFailedWithRequest:request];
}

- (void)moogleRequestDidFinish:(ASIHTTPRequest *)request {
  DLog(@"Data center Finished with response: %@", [request responseString]);
  
  if (_parsedResponse) {
    [_parsedResponse release];
    _parsedResponse = nil;
  }
  _parsedResponse = [[[CJSONDeserializer deserializer] deserialize:[request responseData] error:nil] retain];
  
  [self dataCenterFinishedWithRequest:request];
}

- (void)dataCenterFinishedWithRequest:(ASIHTTPRequest *)request {
  // Inform delegate the operation Finished
  if (self.delegate) {
    [self.delegate retain];
    if ([self.delegate respondsToSelector:@selector(dataCenterDidFinish:)]) {
      [self.delegate performSelector:@selector(dataCenterDidFinish:) withObject:request];
    }
    [self.delegate release];
  }
}

- (void)dataCenterFailedWithRequest:(ASIHTTPRequest *)request {
  // Inform delegate the operation Failed
  if (self.delegate) {
    [self.delegate retain];
    if ([self.delegate respondsToSelector:@selector(dataCenterDidFail:)]) {
      [self.delegate performSelector:@selector(dataCenterDidFail:) withObject:request];
    }
    [self.delegate release];
  }
}

- (void)dealloc {
  RELEASE_SAFELY (_parsedResponse);
  [super dealloc];
}

@end
