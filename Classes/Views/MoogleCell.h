//
//  MoogleCell.h
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "NSDate+HumanInterval.h"

#define SPACING_X 7.0
#define LABEL_HEIGHT 24.0

@interface MoogleCell : UITableViewCell {
  UIActivityIndicatorView *_imageLoadingIndicator;
}

@end
