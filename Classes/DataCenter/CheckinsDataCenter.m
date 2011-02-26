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

@synthesize responseArray = _responseArray;

- (void)requestFinished:(ASIHTTPRequest *)request {
  DLog(@"Request Finished with Status Code: %d, : %@", [request responseStatusCode], request);
  // This is on the main thread
  NSInteger statusCode = [request responseStatusCode];
  if(statusCode > 200) {
    [self dataCenterFailedWithRequest:request];
  } else {
    // Successful request
    [self checkinsRequestDidFinish:request];
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
  
  NSArray *keys = [NSArray arrayWithObjects:@"checkin_id", @"facebook_id", @"name", @"place_id", @"place_name", @"message", @"checkin_timestamp", nil];
  
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

//{"checkin_id":108918675852472,"facebook_id":100002030219173,"name":"Moseven Moog","message":null,"place_id":109339952438834,"place_name":"Sono Sushi","app_id":6628568379,"app_name":"Facebook for iPhone","checkin_timestamp":1297216182}

- (void)dealloc {
  RELEASE_SAFELY(_responseArray);
  [super dealloc];
}

@end
