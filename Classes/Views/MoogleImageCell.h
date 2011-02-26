//
//  MoogleImageCell.h
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoogleCell.h"

#define SPACING_X 7.0
#define LABEL_HEIGHT 24.0

@interface MoogleImageCell : MoogleCell {
  UIActivityIndicatorView *_imageLoadingIndicator;
}

@end
