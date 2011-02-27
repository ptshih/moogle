//
//  ImageCache.h
//  Friendmash
//
//  Created by Peter Shih on 11/9/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageCacheDelegate.h"

@class ASIHTTPRequest;

@interface ImageCache : NSObject {
  NSMutableDictionary *_imageCache;
  NSMutableDictionary *_pendingRequests;
  id <ImageCacheDelegate> delegate;
}

@property (nonatomic, retain) NSMutableDictionary *imageCache;
@property (nonatomic, retain) NSMutableDictionary *pendingRequests;
@property (nonatomic, assign) id <ImageCacheDelegate> delegate;

- (void)resetCache;
- (void)cacheImageWithURL:(NSURL *)url forIndexPath:(NSIndexPath *)indexPath;
- (UIImage *)getImageWithURL:(NSURL *)url;
- (void)imageLoadDidFinish:(ASIHTTPRequest *)request;
- (void)imageLoadDidError:(ASIHTTPRequest *)request;

/**
 These 2 methods are used to 
 */
- (NSString *)encodeIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)decodeIndexPath:(NSString *)encodedIndexPath;
  
@end
