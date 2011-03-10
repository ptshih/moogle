//
//  SMAURLCache.m
//  InPad
//
//  Created by Peter Shih on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SMAURLCache.h"

static SMAURLCache *_sharedCache;

@implementation SMAURLCache

@synthesize imageCache = _imageCache;
@synthesize htmlCache = _htmlCache;

+ (SMAURLCache *)sharedCache {
  if (!_sharedCache) {
    _sharedCache = [[self alloc] init];
  }
  return _sharedCache;
}

// HTML Cache
- (void)cacheHTML:(NSData *)html forURLPath:(NSString *)urlPath {
  if (!_htmlCache) {
    _htmlCache = [[NSMutableDictionary alloc] init];
  }
  
  [self.htmlCache setObject:html forKey:urlPath];
}

- (NSString *)htmlForURLPath:(NSString *)urlPath {
  NSData *data = [self.htmlCache objectForKey:urlPath];
	if (data) {
    return [[[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding] autorelease];
	} else {
    return nil;
  }
}

- (BOOL)hasHTMLForURLPath:(NSString *)urlPath {
  return ([self.htmlCache objectForKey:urlPath] != nil);
}

// Image Cache
- (void)cacheImage:(UIImage *)image forURLPath:(NSString *)urlPath {
  if (!_imageCache) {
    _imageCache = [[NSMutableDictionary alloc] init];
  }
  
  [self.imageCache setObject:image forKey:urlPath];
}

- (UIImage *)imageForURLPath:(NSString *)urlPath {
  return [self.imageCache objectForKey:urlPath];
}

- (BOOL)hasImageForURLPath:(NSString *)urlPath {
  return ([self.imageCache objectForKey:urlPath] != nil);
}

#pragma mark Memory Management
+ (id)allocWithZone:(NSZone *)zone {
  @synchronized(self) {
    if (_sharedCache == nil) {
      _sharedCache = [super allocWithZone:zone];
      return _sharedCache;
    }
  }
  return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
  return self;
}

- (id)retain {
  return self;
}

- (unsigned)retainCount {
  return UINT_MAX;
}

- (void)release {
  // do nothing
}

- (id)autorelease {
  return self;
}

@end
