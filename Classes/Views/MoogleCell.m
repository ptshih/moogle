//
//  MoogleCell.m
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MoogleCell.h"


@implementation MoogleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    if ([[self class] cellType] == MoogleCellTypePlain) {
      self.backgroundView = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"table_cell_bg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:30]] autorelease];
      self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"table_cell_bg_selected.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:30]] autorelease];
    }
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
}

- (void)layoutSubviews {
  [super layoutSubviews];
}

+ (MoogleCellType)cellType {
  return MoogleCellTypePlain;
}

+ (CGFloat)rowHeight {
  // Subclasses should override
  return 44.0;
}

+ (CGFloat)variableRowHeightWithDictionary:(NSDictionary *)dictionary {
  return 0.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)dealloc {
  [super dealloc];
}

@end
