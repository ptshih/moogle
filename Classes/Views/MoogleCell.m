//
//  MoogleCell.m
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MoogleCell.h"


@implementation MoogleCell

@synthesize desiredHeight = _desiredHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _desiredHeight = 0.0;
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
}

- (void)layoutSubviews {
  [super layoutSubviews];
}

+ (CGFloat)rowHeight {
  // Subclasses should override
  return 44.0;
}

+ (CGFloat)variableRowHeightForCell:(id)cell {
  return [cell desiredHeight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)dealloc {
  [super dealloc];
}

@end
