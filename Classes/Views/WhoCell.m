//
//  WhoCell.m
//  Moogle
//
//  Created by Peter Shih on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WhoCell.h"

@implementation WhoCell

@synthesize isSelected = _isSelected;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _isSelected = NO;
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  self.smaImageView.width = 34.0;
  self.smaImageView.height = 34.0;
  
  self.textLabel.left = self.smaImageView.right + SPACING_X;
}

+ (void)fillCell:(WhoCell *)cell withDictionary:(NSDictionary *)dictionary forType:(WhoCellType)type {  
  cell.smaImageView.placeholderImage = [UIImage imageNamed:@"tab_friends.png"];

  if (type == WhoCellTypeFriend) {
    cell.smaImageView.urlPath = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [dictionary objectForKey:@"friend_id"]];
    cell.textLabel.text = [dictionary valueForKey:@"friend_name"];
  } else {
    cell.textLabel.text = [dictionary valueForKey:@"group_name"];
  }
  
  [cell.smaImageView loadImage];
}

+ (MoogleCellType)cellType {
  return MoogleCellTypeGrouped;
}

+ (CGFloat)rowHeight {
  return 44.0;
}

- (void)dealloc {
  [super dealloc];
}

@end
