//
//  FriendCell.m
//  Moogle
//
//  Created by Peter Shih on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FriendCell.h"


@implementation FriendCell

- (void)layoutSubviews {
  [super layoutSubviews];
  
  self.smaImageView.width = 34;
  self.smaImageView.height = 34;
  
  self.textLabel.left = self.smaImageView.right + SPACING_X;
}

+ (MoogleCellType)cellType {
  return MoogleCellTypeGrouped;
}

+ (CGFloat)rowHeight {
  // Subclasses should override
  return 44.0;
}

@end
