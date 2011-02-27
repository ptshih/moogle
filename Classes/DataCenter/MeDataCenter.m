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
  
  if (!_responseArray) {
    _responseArray = [[NSMutableArray array] retain];
  } else {
    [_responseArray removeAllObjects];
  }
  
  NSArray *jsonArray = [[CJSONDeserializer deserializer] deserialize:[request responseData] error:nil];
  
  NSArray *kupoKeys = [NSArray arrayWithObjects:@"place_id", @"place_name", @"checkin_time", @"user_facebook_id", @"user_name", @"your_last_checkin_time", @"your_facebook_id", nil];
  
  for (NSDictionary *item in jsonArray) {
    NSMutableDictionary *responseDict = [NSMutableDictionary dictionary];
    for (NSString *key in kupoKeys) {
      NSString *value = nil;
      value = [item valueForKey:key];
      
      if (![value notNil]) {
        // Check for not nil object
        [responseDict setObject:[NSNumber numberWithInteger:0] forKey:key];
      } else {
        [responseDict setObject:value forKey:key];
      }
    }
    [self.responseArray addObject:responseDict];
  }
  
  [self dataCenterFinishedWithRequest:request];
}

- (void)dealloc {
  RELEASE_SAFELY(_responseArray);
  [super dealloc];
}

@end
