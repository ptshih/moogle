//
//  RemoteRequest.m
//  Friendmash
//
//  Created by Peter Shih on 11/10/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "RemoteRequest.h"
#import "ASIHTTPRequest.h"
#import "NSString+Util.h"
#import "HashValue.h"
#import "Constants.h"

static NSString *_secretString = nil;

@implementation RemoteRequest

+ (void)load {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  // Calculate SHA256 hash for secret
  HashValue *secretHash = [HashValue sha256HashWithData:[@"omgwtfbbqflylikeag6" dataUsingEncoding:NSUTF8StringEncoding]];
  _secretString = [[secretHash description] retain];
  [pool drain];
}

+ (ASIHTTPRequest *)getRequestWithBaseURLString:(NSString *)baseURLString andParams:(NSMutableDictionary *)params withDelegate:(id)delegate {
  [params setObject:[APP_DELEGATE.fbAccessToken stringWithPercentEscape] forKey:@"access_token"];
  NSString *paramsString = [self getStringWithParams:params];
  NSString *getURLString = [NSString stringWithFormat:@"%@?%@", baseURLString, paramsString];
  NSURL *getURL = [NSURL URLWithString:getURLString];
  
  ASIHTTPRequest *getRequest = [ASIHTTPRequest requestWithURL:getURL];
  [getRequest setDelegate:delegate];
  [getRequest setTimeOutSeconds:120];
  [getRequest setNumberOfTimesToRetryOnTimeout:2];
  [getRequest setAllowCompressedResponse:YES];
  [getRequest addRequestHeader:@"Content-Type" value:@"application/json"];
  [getRequest addRequestHeader:@"Accept" value:@"application/json"];
  [getRequest setRequestMethod:@"GET"];
  [getRequest addRequestHeader:@"X-UDID" value:[[UIDevice currentDevice] uniqueIdentifier]];
  [getRequest addRequestHeader:@"X-Device-Model" value:[[UIDevice currentDevice] model]];
  [getRequest addRequestHeader:@"X-App-Version" value:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
  [getRequest addRequestHeader:@"X-System-Name" value:[[UIDevice currentDevice] systemName]];
  [getRequest addRequestHeader:@"X-System-Version" value:[[UIDevice currentDevice] systemVersion]];
  [getRequest addRequestHeader:@"X-Connection-Type" value:[NSString stringWithFormat:@"%d",APP_DELEGATE.netStatus]];
  [getRequest addRequestHeader:@"X-User-Language" value:USER_LANGUAGE];
  [getRequest addRequestHeader:@"X-User-Locale" value:USER_LOCALE];
  if(APP_DELEGATE.sessionKey) [getRequest addRequestHeader:@"X-Session-Key" value:APP_DELEGATE.sessionKey];
//  if(APP_DELEGATE.fbUserId) [getRequest addRequestHeader:@"X-User-Id" value:APP_DELEGATE.fbUserId];
  [getRequest addRequestHeader:@"X-Friendmash-Secret" value:_secretString];
  
  return getRequest;
}

+ (ASIHTTPRequest *)postRequestWithBaseURLString:(NSString *)baseURLString andParams:(NSMutableDictionary *)params isGzip:(BOOL)isGzip withDelegate:(id)delegate {
  // Send access_token as a parameter
  [params setObject:[APP_DELEGATE.fbAccessToken stringWithPercentEscape] forKey:@"access_token"];
  
  // Build parameters as postData
  NSData *postData = [self postDataWithParams:params];
  NSURL *postURL = [NSURL URLWithString:baseURLString];
  
  ASIHTTPRequest *postRequest = [ASIHTTPRequest requestWithURL:postURL];

  [postRequest setDelegate:delegate];
  [postRequest setTimeOutSeconds:120];
  [postRequest setNumberOfTimesToRetryOnTimeout:2];
  [postRequest setRequestMethod:@"POST"];
  [postRequest setShouldCompressRequestBody:isGzip]; // GZIP the postData
//  [postRequest addRequestHeader:@"Content-Type" value:@"application/json"];
  [postRequest addRequestHeader:@"Accept" value:@"application/json"];
  [postRequest addRequestHeader:@"X-UDID" value:[[UIDevice currentDevice] uniqueIdentifier]];
  [postRequest addRequestHeader:@"X-Device-Model" value:[[UIDevice currentDevice] model]];
  [postRequest addRequestHeader:@"X-App-Version" value:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
  [postRequest addRequestHeader:@"X-System-Name" value:[[UIDevice currentDevice] systemName]];
  [postRequest addRequestHeader:@"X-System-Version" value:[[UIDevice currentDevice] systemVersion]];
  [postRequest addRequestHeader:@"X-Connection-Type" value:[NSString stringWithFormat:@"%d",APP_DELEGATE.netStatus]];
  [postRequest addRequestHeader:@"X-User-Language" value:USER_LANGUAGE];
  [postRequest addRequestHeader:@"X-User-Locale" value:USER_LOCALE];
  if(APP_DELEGATE.sessionKey) [postRequest addRequestHeader:@"X-Session-Key" value:APP_DELEGATE.sessionKey];
//  if(APP_DELEGATE.fbUserId) [postRequest addRequestHeader:@"X-User-Id" value:APP_DELEGATE.fbUserId];
  [postRequest addRequestHeader:@"X-Friendmash-Secret" value:_secretString];
  [postRequest setPostLength:[postData length]];
  [postRequest setPostBody:(NSMutableData *)postData];
  
  return postRequest;
}

#pragma mark Facebook API
+ (ASIHTTPRequest *)postFacebookCheckinRequestWithParams:(NSMutableDictionary *)params withDelegate:(id)delegate {
  [params setObject:[APP_DELEGATE.fbAccessToken stringWithPercentEscape] forKey:@"access_token"];
  
//  NSString *token = [NSString stringWithFormat:@"access_token=%@", [APP_DELEGATE.fbAccessToken stringWithPercentEscape]];
//  NSString *coordinates = [NSString stringWithFormat:@"&coordinates={\"latitude\":\"%@\", \"longitude\":\"%@\"}", [[params objectForKey:@"coordinates"] objectForKey:@"latitude"], [[params objectForKey:@"coordinates"] objectForKey:@"longitude"]];
//  NSString *place = [NSString stringWithFormat:@"&place=%@", [params objectForKey:@"place"]];
  
  NSString *baseURLString = [NSString stringWithFormat:@"%@/checkins", FB_GRAPH_ME];
  
  NSData *postData = [self postDataWithParams:params];
  
  ASIHTTPRequest *checkinRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:baseURLString]];
  [checkinRequest setDelegate:delegate];
  [checkinRequest setNumberOfTimesToRetryOnTimeout:2];
  [checkinRequest setRequestMethod:@"POST"];
  [checkinRequest setPostBody:(NSMutableData *)postData];
  
//  [checkinRequest appendPostData:[token dataUsingEncoding:NSUTF8StringEncoding]];
//  [checkinRequest appendPostData:[place dataUsingEncoding:NSUTF8StringEncoding]];
//  [checkinRequest appendPostData:[coordinates dataUsingEncoding:NSUTF8StringEncoding]];
  
  return checkinRequest;
}

+ (ASIHTTPRequest *)getFacebookRequestForMeWithDelegate:(id)delegate {
  NSString *token = [APP_DELEGATE.fbAccessToken stringWithPercentEscape];
  NSString *fields = FB_PARAMS;
  NSString *params = [NSString stringWithFormat:@"access_token=%@&fields=%@", token, fields];
  NSString *baseURLString = [NSString stringWithFormat:@"%@?%@", FB_GRAPH_ME, params];
  
  ASIHTTPRequest *meRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:baseURLString]];
  [meRequest setNumberOfTimesToRetryOnTimeout:2];
  [meRequest setAllowCompressedResponse:YES];
  [meRequest setDelegate:delegate];
  
  return meRequest;
}

+ (ASIHTTPRequest *)getFacebookRequestForFriendsWithDelegate:(id)delegate {
  NSString *token = [APP_DELEGATE.fbAccessToken stringWithPercentEscape];
  NSString *fields = FB_PARAMS;
  NSString *params = [NSString stringWithFormat:@"access_token=%@&fields=%@", token, fields];
  NSString *baseURLString = [NSString stringWithFormat:@"%@?%@", FB_GRAPH_FRIENDS, params];
  
  ASIHTTPRequest *friendsRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:baseURLString]];
  [friendsRequest setNumberOfTimesToRetryOnTimeout:2];
  [friendsRequest setAllowCompressedResponse:YES];
  [friendsRequest setDelegate:delegate];
  
  return friendsRequest;
}

+ (ASIHTTPRequest *)getFacebookRequestForPictureWithFacebookId:(NSString *)facebookId andType:(NSString *)type withDelegate:(id)delegate {
  NSString *token = [APP_DELEGATE.fbAccessToken stringWithPercentEscape];
  NSString *params = [NSString stringWithFormat:@"access_token=%@&type=%@", token, type];
  NSString *baseURLString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?%@", facebookId, params];
  
  ASIHTTPRequest *pictureRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:baseURLString]];
  [pictureRequest setNumberOfTimesToRetryOnTimeout:2];
  [pictureRequest setDelegate:delegate];
  
  return pictureRequest;
}

+ (NSString *)serializeURL:(NSString *)baseUrl
                    params:(NSDictionary *)params {
  return [self serializeURL:baseUrl params:params httpMethod:@"GET"];
}

/**
 * Generate get URL
 */
+ (NSString*)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params
               httpMethod:(NSString *)httpMethod {
  
  NSURL* parsedURL = [NSURL URLWithString:baseUrl];
  NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
  
  NSMutableArray* pairs = [NSMutableArray array];
  for (NSString* key in [params keyEnumerator]) {
    if (([[params valueForKey:key] isKindOfClass:[UIImage class]])
        ||([[params valueForKey:key] isKindOfClass:[NSData class]])) {
      if ([httpMethod isEqualToString:@"GET"]) {
        DLog(@"can not use GET to upload a file");
      }
      continue;
    }
    
    NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL, /* allocator */
                                                                                  (CFStringRef)[params objectForKey:key],
                                                                                  NULL, /* charactersToLeaveUnescaped */
                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                  kCFStringEncodingUTF8);
    
    [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
    [escaped_value release];
  }
  NSString* query = [pairs componentsJoinedByString:@"&"];
  
  return [NSString stringWithFormat:@"%@%@%@", baseUrl, queryPrefix, query];
}

+ (NSData *)postDataWithParams:(NSDictionary *)params {  
  NSMutableString *encodedParameterPairs = [[NSMutableString alloc] initWithCapacity:256];
  
  NSArray *allKeys = [params allKeys];
  NSArray *allValues = [params allValues];
  
  for (int i = 0; i < [params count]; i++) {
    [encodedParameterPairs appendFormat:@"%@=%@", [[allKeys objectAtIndex:i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[allValues objectAtIndex:i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (i < [params count] - 1) {
      [encodedParameterPairs appendString:@"&"];
    }
  }
  
  return [encodedParameterPairs dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
}

+ (NSString *)getStringWithParams:(NSDictionary *)params {
  NSMutableString *encodedParameterPairs = [[NSMutableString alloc] initWithCapacity:256];
  
  NSArray *allKeys = [params allKeys];
  NSArray *allValues = [params allValues];
  
  for (int i = 0; i < [params count]; i++) {
    [encodedParameterPairs appendFormat:@"%@=%@", [[allKeys objectAtIndex:i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[allValues objectAtIndex:i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (i < [params count] - 1) {
      [encodedParameterPairs appendString:@"&"];
    }
  }
  
  return encodedParameterPairs;
}

@end
