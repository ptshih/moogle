//
//  SMAImageView.h
//  InPad
//
//  Created by Peter Shih on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteOperation.h"
//#import "ASIHTTPRequestDelegate.h"
#import "ASIHTTPRequest.h"

@interface SMAImageView : UIImageView {
  NSString *_urlPath;
  UIImage *_placeholderImage;
  ASIHTTPRequest *_imageRequest;
}

@property (nonatomic, copy) NSString *urlPath;
@property (nonatomic, retain) UIImage *placeholderImage;

- (void)loadImage;
- (void)loadImageIfCached;
- (void)unloadImage;

@end
