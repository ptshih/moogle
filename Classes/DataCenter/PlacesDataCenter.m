//
//  PlacesDataCenter.m
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlacesDataCenter.h"

@interface PlacesDataCenter (Private)

- (void)nearbyRequestDidFinish:(ASIHTTPRequest *)request;

@end


@implementation PlacesDataCenter

@synthesize responseArray = _responseArray;

- (void)requestFinished:(ASIHTTPRequest *)request {
  DLog(@"Request Finished with Status Code: %d, : %@", [request responseStatusCode], request);
  // This is on the main thread
  NSInteger statusCode = [request responseStatusCode];
  if(statusCode > 200) {
    [self dataCenterFailedWithRequest:request];
  } else {
    // Successful request
    [self nearbyRequestDidFinish:request];
  }
}

- (void)nearbyRequestDidFinish:(ASIHTTPRequest *)request {
  DLog(@"Successfully got a list of nearby places with response: %@", [request responseString]);

  if (!_responseArray) {
    _responseArray = [[NSMutableArray array] retain];
  } else {
    [_responseArray removeAllObjects];
  }
  
  NSArray *jsonArray = [[CJSONDeserializer deserializer] deserialize:[request responseData] error:nil];
  
  NSArray *keys = [NSArray arrayWithObjects:@"place_id", @"place_name", @"checkins_count", @"checkins_friend_count", @"like_count", @"distance", nil];  
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

//{"place_id":136712346393617,"name":"Subway","street":"790 Montague Expressway","city":"San Jose","state":"California","country":null,"zip":"95131","phone":null,"checkins_count":5,"distance":0.6116674739209772,"checkins_friend_count":0,"like_count":null,"attire":null,"website":null,"price":null}

- (void)dealloc {
  RELEASE_SAFELY(_responseArray);
  [super dealloc];
}

@end
