//
//  SMAURLCache.h
//  InPad
//
//  Created by Peter Shih on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SMAURLCache : NSObject {
  NSMutableDictionary *_imageCache;
  NSMutableDictionary *_htmlCache;
}

@property (retain) NSMutableDictionary *imageCache;
@property (retain) NSMutableDictionary *htmlCache;

+ (SMAURLCache *)sharedCache;

// HTML Cache
- (void)cacheHTML:(NSData *)html forURLPath:(NSString *)urlPath;
- (NSString *)htmlForURLPath:(NSString *)urlPath;
- (BOOL)hasHTMLForURLPath:(NSString *)urlPath;

// Image Cache
- (void)cacheImage:(UIImage *)image forURLPath:(NSString *)urlPath;
- (UIImage *)imageForURLPath:(NSString *)urlPath;
- (BOOL)hasImageForURLPath:(NSString *)urlPath;

@end
