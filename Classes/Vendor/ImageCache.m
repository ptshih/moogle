//
//  ImageCache.m
//  Friendmash
//
//  Created by Peter Shih on 11/9/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "ImageCache.h"
#import "ASIHTTPRequest.h"
#import "RemoteRequest.h"
#import "RemoteOperation.h"
#import "CJSONDeserializer.h"
#import "Constants.h"

@implementation ImageCache

@synthesize imageCache = _imageCache;
@synthesize pendingRequests = _pendingRequests;
@synthesize delegate;

- (id)init {
  self = [super init];
  if (self) {
    _imageCache = [[NSMutableDictionary alloc] init];
    _pendingRequests = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void)resetCache {
  for (ASIHTTPRequest *pendingRequest in [self.pendingRequests allValues]) {
    [pendingRequest clearDelegatesAndCancel];
  }
  
  [self.imageCache removeAllObjects];
  [self.pendingRequests removeAllObjects];
}

- (NSString *)encodeIndexPath:(NSIndexPath *)indexPath {
  return [NSString stringWithFormat:@"%d,%d", indexPath.row, indexPath.section];
}

- (NSIndexPath *)decodeIndexPath:(NSString *)encodedIndexPath {
  NSArray *decodedArray = [encodedIndexPath componentsSeparatedByString:@","];
  return [NSIndexPath indexPathForRow:[[decodedArray objectAtIndex:0] integerValue] inSection:[[decodedArray objectAtIndex:1] integerValue]];
}

- (void)cacheImageWithURL:(NSURL *)url forIndexPath:(NSIndexPath *)indexPath {
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
  request.delegate = self;
  [request setNumberOfTimesToRetryOnTimeout:2];
  [self.pendingRequests setObject:request forKey:[self encodeIndexPath:indexPath]];
  [[RemoteOperation sharedInstance] addRequestToQueue:request];
  
}

- (UIImage *)getImageForIndexPath:(NSIndexPath *)indexPath {
  return [self.imageCache objectForKey:[self encodeIndexPath:indexPath]];
}

#pragma mark ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
  NSInteger statusCode = [request responseStatusCode];
  if (statusCode > 200) {
    // Error
  } else {
    if ([[self.pendingRequests allKeysForObject:request] count] > 0) {
      NSString *encodedIndexPath = [[self.pendingRequests allKeysForObject:request] objectAtIndex:0];
      [self.pendingRequests removeObjectForKey:encodedIndexPath];
      [self.imageCache setObject:[UIImage imageWithData:[request responseData]] forKey:encodedIndexPath];
      if([delegate respondsToSelector:@selector(imageDidLoad:)]) {
        [delegate imageDidLoad:[self decodeIndexPath:encodedIndexPath]];
      }
    }
  }
}


- (void)dealloc {
  [self resetCache];
  RELEASE_SAFELY(_pendingRequests);
  RELEASE_SAFELY(_imageCache);

  [super dealloc];
}


@end
