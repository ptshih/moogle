//
//  SMAImageView.h
//  InPad
//
//  Created by Peter Shih on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "ASIHTTPRequest.h"

@interface SMAImageView : UIImageView <ASIHTTPRequestDelegate> {
  NSString *_urlPath;
  UIImage *_placeholderImage;
}

@property (nonatomic, copy) NSString *urlPath;
@property (nonatomic, retain) UIImage *placeholderImage;

@end
