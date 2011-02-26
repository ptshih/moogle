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

@end

@implementation PlacesDataCenter

@synthesize checkinHereRequest = _checkinHereRequest;
@synthesize placeInfoRequest = _placeInfoRequest;

@synthesize headersArray = _headersArray;
@synthesize detailsArray = _detailsArray;

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
    }
  }
}

- (void)checkinHereRequestDidFinish:(ASIHTTPRequest *)request {
  DLog(@"Successfully posted a checkin to facebook with response: %@", [request responseString]);
  
  [self dataCenterFinishedWithRequest:request];
}

- (void)placeInfoRequestDidFinish:(ASIHTTPRequest *)request {
  DLog(@"Successfully got place with response: %@", [request responseString]);
  
  NSDictionary *responseDict = [[CJSONDeserializer deserializer] deserialize:[request responseData] error:nil];
  
  // Create the items and the sections for the controller to display
  
  // Header
  _headersArray = [[NSMutableArray array] retain];
  NSArray *headerKeys = [NSArray arrayWithObjects:@"place_id", @"name", @"checkins_count", @"checkins_friend_count", @"like_count", nil];
  NSMutableDictionary *headerDict = [NSMutableDictionary dictionary];
  for (NSString *key in headerKeys) {
    [headerDict setObject:[responseDict objectForKey:key] forKey:key];
  }
  [self.headersArray addObject:headerDict];
  
  // Details
  _detailsArray = [[NSMutableArray array] retain];
  NSArray *detailsKeys = [NSArray arrayWithObjects:@"distance", @"phone", nil];
  for (NSString *key in detailsKeys) {
    NSString *value = nil;
    // Check for distance and transform
    if ([key isEqualToString:@"distance"]) {
      value = [NSString stringWithFormat:@"%.2fmi", [[responseDict valueForKey:key] floatValue]];
    } else {
      value = [responseDict valueForKey:key];
    }
    
    // Check for nulls
    if ([value notNil]) {
      [self.detailsArray addObject:[NSDictionary dictionaryWithObject:value forKey:key]]; 
    }
  }
  
  [self dataCenterFinishedWithRequest:request];
}

- (void)dealloc {
  RELEASE_SAFELY(_headersArray);
  RELEASE_SAFELY(_detailsArray);
  [super dealloc];
}

@end
