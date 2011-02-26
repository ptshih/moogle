//
//  PlacesDataCenter.m
//  Moogle
//
//  Created by Peter Shih on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlacesDataCenter.h"
#import "CJSONDeserializer.h"

@interface PlacesDataCenter (Private)

- (void)checkinHereRequestDidFinish:(ASIHTTPRequest *)request;
- (void)placeInfoRequestDidFinish:(ASIHTTPRequest *)request;
- (void)placeActivityRequestDidFinish:(ASIHTTPRequest *)request;
- (void)placeReviewsRequestDidFinish:(ASIHTTPRequest *)request;

@end

@implementation PlacesDataCenter

@synthesize checkinHereRequest = _checkinHereRequest;
@synthesize placeInfoRequest = _placeInfoRequest;
@synthesize placeActivityRequest = _placeActivityRequest;
@synthesize placeReviewsRequest = _placeReviewsRequest;

@synthesize headersArray = _headersArray;
@synthesize detailsArray = _detailsArray;
@synthesize activityArray = _activityArray;

- (void)requestFinished:(ASIHTTPRequest *)request {
  DLog(@"Request Finished with Status Code: %d, : %@", [request responseStatusCode], request);
  // This is on the main thread
  NSInteger statusCode = [request responseStatusCode];
  if(statusCode > 200) {
    [self dataCenterFailedWithRequest:request];
  } else {
    // Successful request
    if ([request isEqual:self.checkinHereRequest]) {
      // This is a post to facebook checkin request
      [self checkinHereRequestDidFinish:request];
    } else if ([request isEqual:self.placeInfoRequest]) {
      // This is a get request from moogle for place info
      [self placeInfoRequestDidFinish:request];
    } else if ([request isEqual:self.placeActivityRequest]) {
      // This is a get request from moogle for place activity
      [self placeActivityRequestDidFinish:request];
    } else if ([request isEqual:self.placeReviewsRequest]) {
      // This is a get request from moogle for place reviews
      [self placeReviewsRequestDidFinish:request];
    }
  }
}

- (void)checkinHereRequestDidFinish:(ASIHTTPRequest *)request {
  DLog(@"Successfully posted a checkin to facebook with response: %@", [request responseString]);
  
  [self dataCenterFinishedWithRequest:request];
}

- (void)placeInfoRequestDidFinish:(ASIHTTPRequest *)request {
  DLog(@"Successfully got place with response: %@", [request responseString]);
  
  NSDictionary *jsonDict = [[CJSONDeserializer deserializer] deserialize:[request responseData] error:nil];
  
  // Create the items and the sections for the controller to display
  
  // Header
  if (!_headersArray) {
    _headersArray = [[NSMutableArray array] retain];
  } else {
    [_headersArray removeAllObjects];
  }
  NSArray *headerKeys = [NSArray arrayWithObjects:@"place_id", @"name", @"checkins_count", @"checkins_friend_count", @"like_count", nil];
  NSMutableDictionary *headerDict = [NSMutableDictionary dictionary];
  for (NSString *key in headerKeys) {
    [headerDict setObject:[jsonDict objectForKey:key] forKey:key];
  }
  [self.headersArray addObject:headerDict];
  
  // Details
  if (!_detailsArray) {
    _detailsArray = [[NSMutableArray array] retain];
  } else {
    [_detailsArray removeAllObjects];
  }
  NSArray *detailsKeys = [NSArray arrayWithObjects:@"distance", @"phone", nil];
  for (NSString *key in detailsKeys) {
    NSString *value = nil;
    // Check for distance and transform
    if ([key isEqualToString:@"distance"]) {
      value = [NSString stringWithFormat:@"%.2fmi", [[jsonDict valueForKey:key] floatValue]];
    } else {
      value = [jsonDict valueForKey:key];
    }
    
    // Check for nulls
    if ([value notNil]) {
      [self.detailsArray addObject:[NSDictionary dictionaryWithObject:value forKey:key]]; 
    }
  }
  
  [self dataCenterFinishedWithRequest:request];
}

- (void)placeActivityRequestDidFinish:(ASIHTTPRequest *)request {
//  [{"facebook_id":100002020589088,"message":null,"name":"Mosix Moog","timestamp":1298357098},{"facebook_id":100002030219173,"message":null,"name":"Moseven Moog","timestamp":1298357098},{"facebook_id":100002031089048,"message":null,"name":"Mothree Moog","timestamp":1298357098},{"facebook_id":100002039668743,"message":null,"name":"Motwo Moog","timestamp":1298357098},{"facebook_id":100002020589088,"message":null,"name":"Mosix Moog","timestamp":1298357098},{"facebook_id":100002030219173,"message":null,"name":"Moseven Moog","timestamp":1298357098},{"facebook_id":100002031089048,"message":null,"name":"Mothree Moog","timestamp":1298357098},{"facebook_id":100002039668743,"message":null,"name":"Motwo Moog","timestamp":1298357098},{"facebook_id":100002020589088,"message":null,"name":"Mosix Moog","timestamp":1298357098},{"facebook_id":100002030219173,"message":null,"name":"Moseven Moog","timestamp":1298357098}]
  
  NSArray *jsonArray = [[CJSONDeserializer deserializer] deserialize:[request responseData] error:nil];
  
  if (!_activityArray) {
    _activityArray = [[NSMutableArray array] retain];
  } else {
    [_activityArray removeAllObjects];
  }
  
  NSArray *activityKeys = [NSArray arrayWithObjects:@"facebook_id", @"name", @"message", @"timestamp", nil];
  
  for (NSDictionary *item in jsonArray) {
    NSMutableDictionary *responseDict = [NSMutableDictionary dictionary];
    for (NSString *key in activityKeys) {
      NSString *value = nil;
      value = [item valueForKey:key];
      
      if (![value notNil]) {
        // Check for not nil object
        [responseDict setObject:[NSNumber numberWithInteger:0] forKey:key];
      } else {
        [responseDict setObject:value forKey:key];
      }
    }
    [self.activityArray addObject:responseDict];
  }
  
  [self dataCenterFinishedWithRequest:request];
}

- (void)placeReviewsRequestDidFinish:(ASIHTTPRequest *)request {
  [self dataCenterFinishedWithRequest:request];
}

- (void)dealloc {
  RELEASE_SAFELY(_headersArray);
  RELEASE_SAFELY(_detailsArray);
  RELEASE_SAFELY(_activityArray);
  [super dealloc];
}

@end
