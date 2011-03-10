//
//  SMAImageView.m
//  InPad
//
//  Created by Peter Shih on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SMAImageView.h"
#import "SMAURLCache.h"

@implementation SMAImageView

@synthesize urlPath = _urlPath;
@synthesize placeholderImage = _placeholderImage;

// Override Setter
- (void)setUrlPath:(NSString *)urlPath {
  if (urlPath) {
    NSString* urlPathCopy = [urlPath copy];
    [_urlPath release];
    _urlPath = urlPathCopy;
    
    if ([[SMAURLCache sharedCache] hasImageForURLPath:_urlPath]) {
      // Image found in cache
      self.image = [[SMAURLCache sharedCache] imageForURLPath:_urlPath];
    } else {
      // Image not found in cache, fire a request
      ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_urlPath]];
      request.delegate = self;
      [request startAsynchronous];
    }
  } else {
    self.image = self.placeholderImage;
  }
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
  [_urlPath release], _urlPath = nil;
  [_placeholderImage release], _placeholderImage = nil;
  
  [super dealloc];
}
@end
