//
//  MoogleImageCell.h
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MoogleCell.h"
#import "SMAImageView.h"

#define IMAGE_WIDTH_PLAIN 40.0
#define IMAGE_HEIGHT_PLAIN 40.0
#define IMAGE_WIDTH_GROUPED 34.0
#define IMAGE_HEIGHT_GROUPED 34.0
#define SPACING_X 5.0
#define SPACING_Y 5.0

@interface MoogleImageCell : MoogleCell {
  SMAImageView *_smaImageView;
  UIActivityIndicatorView *_imageLoadingIndicator;
}

@property (nonatomic, retain) SMAImageView *smaImageView;

@end
