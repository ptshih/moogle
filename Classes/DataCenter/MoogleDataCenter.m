//
//  MoogleDataCenter.m
//  Moogle
//
//  Created by Peter Shih on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MoogleDataCenter.h"

@interface MoogleDataCenter (Private)

- (BOOL)serializeResponse:(NSData *)responseData;
- (NSDictionary *)sanitizeDictionary:(NSDictionary *)dictionary forKeys:(NSArray *)keys;
- (NSArray *)sanitizeArray:(NSArray *)array;

@end

@implementation MoogleDataCenter

@synthesize delegate = _delegate;
@synthesize response = _response;
@synthesize rawResponse = _rawResponse;
@synthesize responseKeys = _responseKeys;

- (id)init {
  self = [super init];
  if (self) {
    _responseKeys = nil;
  }
  return self;
}

- (NSArray *)sanitizeArray:(NSArray *)array {
  NSMutableArray *sanitizedArray = [NSMutableArray array];
  
  // Loop thru all dictionaries in the array
  NSDictionary *sanitizedDictionary = nil;
  for (NSDictionary *dictionary in array) {
    sanitizedDictionary = [self sanitizeDictionary:dictionary forKeys:[dictionary allKeys]];
    [sanitizedArray addObject:sanitizedDictionary];
  }

  return sanitizedArray;
}
     
- (NSDictionary *)sanitizeDictionary:(NSDictionary *)dictionary forKeys:(NSArray *)keys {
 NSMutableDictionary *sanitizedDictionary = [NSMutableDictionary dictionary];
 
 // Loop thru all keys we expect to get and remove any keys with nil values
 NSString *value = nil;
 for (NSString *key in keys) {
   value = [dictionary valueForKey:key];
   
   if ([value notNil]) {
     [sanitizedDictionary setValue:value forKey:key];
   }
 }
 
 return sanitizedDictionary;
}

- (BOOL)serializeResponse:(NSData *)responseData {
  // Serialize the response
  if (_response) {
    [_response release];
    _response = nil;
  }
  if (_rawResponse) {
    [_rawResponse release];
    _rawResponse = nil;
  }
  
  _rawResponse = [[[CJSONDeserializer deserializer] deserialize:responseData error:nil] retain];
  
  // We should sanitize the response
  if ([_rawResponse isKindOfClass:[NSArray class]]) {
    _response = [[self sanitizeArray:_rawResponse] retain];
  } else if ([_rawResponse isKindOfClass:[NSDictionary class]]) {
    _response = [[self sanitizeDictionary:_rawResponse forKeys:[_rawResponse allKeys]] retain];
  } else {
    // Throw an assertion, why is it not a dictionary or an array???
    DLog(@"### ERROR IN DATA CENTER, RESPONSE IS NEITHER AN ARRAY NOR A DICTIONARY");
  }
  
  if (self.response) {
    return YES;
  } else {
    return NO;
  }
}

#pragma mark ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
  DLog(@"Request Finished with Status Code: %d, : %@", [request responseStatusCode], request);
  // This is on the main thread
  NSInteger statusCode = [request responseStatusCode];
  if(statusCode > 200) {
    [self dataCenterFailedWithRequest:request];
  } else {
    if ([self serializeResponse:[request responseData]]) {
      [self dataCenterFinishedWithRequest:request];
    } else {
      // Something is wrong with the response
      [self dataCenterFailedWithRequest:request];
    }
  }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
  DLog(@"Data center Failed with Error: %@", [request error]);
  [self dataCenterFailedWithRequest:request];
}

#pragma mark Delegate Callbacks
// Subclass should Implement
- (void)dataCenterFinishedWithRequest:(ASIHTTPRequest *)request {
  // By now the response should already be serialized into self.parsedResponse of type id
  
  // Inform delegate the operation Finished
  if (self.delegate) {
    [self.delegate retain];
    if ([self.delegate respondsToSelector:@selector(dataCenterDidFinish:)]) {
      [self.delegate performSelector:@selector(dataCenterDidFinish:) withObject:request];
    }
    [self.delegate release];
  }
}

// Subclass should Implement (Optional)
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

- (void)dataCenterErroredWithRequest:(ASIHTTPRequest *)request {
  // Inform delegate the data center failed to serialized the response
  if (self.delegate) {
    [self.delegate retain];
    if ([self.delegate respondsToSelector:@selector(dataCenterErroredWithRequest:)]) {
      [self.delegate performSelector:@selector(dataCenterDidError:) withObject:request];
    }
    [self.delegate release];
  }
}

- (void)dealloc {
  RELEASE_SAFELY (_response);
  RELEASE_SAFELY(_rawResponse);
  RELEASE_SAFELY(_responseKeys);
  [super dealloc];
}

@end
