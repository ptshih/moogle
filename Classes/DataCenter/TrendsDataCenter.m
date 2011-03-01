//
//  TrendsDataCenter.m
//  Moogle
//
//  Created by Peter Shih on 2/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TrendsDataCenter.h"

@interface TrendsDataCenter (Private)

- (void)trendsRequestDidFinish:(ASIHTTPRequest *)request;

@end

@implementation TrendsDataCenter

@synthesize responseArray = _responseArray;

- (void)requestFinished:(ASIHTTPRequest *)request {
  DLog(@"Request Finished with Status Code: %d, : %@", [request responseStatusCode], request);
  // This is on the main thread
  NSInteger statusCode = [request responseStatusCode];
  if(statusCode > 200) {
    [self dataCenterFailedWithRequest:request];
  } else {
    // Successful request
    [self trendsRequestDidFinish:request];
  }
}

- (void)checkinsRequestDidFinish:(ASIHTTPRequest *)request {
  DLog(@"Successfully got a list of checkins with response: %@", [request responseString]);
  if (!_responseArray) {
    _responseArray = [[NSMutableArray array] retain];
  } else {
    [_responseArray removeAllObjects];
  }
  
  NSArray *jsonArray = [[CJSONDeserializer deserializer] deserialize:[request responseData] error:nil];
  
  NSArray *keys = [NSArray arrayWithObjects:@"checkin_id", @"facebook_id", @"name", @"place_id", @"place_name", @"message", @"checkin_timestamp", @"tagged_count", nil];
  
  for (NSDictionary *item in jsonArray) {
    NSMutableDictionary *responseDict = [NSMutableDictionary dictionary];
    for (NSString *key in keys) {
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
