//
//  SMAImageView.m
//  InPad
//
//  Created by Peter Shih on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SMAImageView.h"
#import "SMAURLCache.h"
#import "Constants.h"

@implementation SMAImageView

@synthesize urlPath = _urlPath;
@synthesize placeholderImage = _placeholderImage;

- (id)init {
  self = [super init];
  if (self) {
    _imageRequest = nil;
  }
  return self;
}
// Override Setter
//- (void)setUrlPath:(NSString *)urlPath {
//
//}

- (void)loadImage {
  if (_urlPath) {    
    if ([[SMAURLCache sharedCache] hasImageForURLPath:_urlPath]) {
      // Image found in cache
      self.image = [[SMAURLCache sharedCache] imageForURLPath:_urlPath];
    } else {
      // Image not found in cache, fire a request
      _imageRequest = [[ASIHTTPRequest requestWithURL:[NSURL URLWithString:_urlPath]] retain];
      _imageRequest.delegate = self;
      [[RemoteOperation sharedInstance] addRequestToQueue:_imageRequest];
    }
  } else {
    self.image = self.placeholderImage;
  }
}

- (void)loadImageIfCached {
  if ([[SMAURLCache sharedCache] hasImageForURLPath:_urlPath]) {
    // Image found in cache
    self.image = [[SMAURLCache sharedCache] imageForURLPath:_urlPath];
  } else {
    self.image = self.placeholderImage;
  }
}

- (void)unloadImage {
  self.image = self.placeholderImage;
}

#pragma mark ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
  UIImage *image = [UIImage imageWithData:[request responseData]];
  [[SMAURLCache sharedCache] cacheImage:image forURLPath:[request.originalURL absoluteString]];
  self.image = image;
}

- (void)requestFailed:(ASIHTTPRequest *)request {
  self.image = self.placeholderImage;
}

- (void)dealloc {
  if (_imageRequest) [_imageRequest clearDelegatesAndCancel];
  RELEASE_SAFELY(_imageRequest);
  RELEASE_SAFELY(_urlPath);
  RELEASE_SAFELY(_placeholderImage);
  
  [super dealloc];
}
@end
