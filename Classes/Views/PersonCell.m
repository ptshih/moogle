//
//  PersonCell.m
//  Moogle
//
//  Created by Peter Shih on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PersonCell.h"

#define CELL_FONT_SIZE 14.0
#define SPACING_X 4.0
#define SPACING_Y 4.0
#define LABEL_HEIGHT 18.0

@implementation PersonCell

@synthesize nameLabel = _nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _nameLabel = [[UILabel alloc] init];
    
    self.nameLabel.backgroundColor = [UIColor clearColor];
    
    self.nameLabel.font = [UIFont boldSystemFontOfSize:CELL_FONT_SIZE];
    
    self.nameLabel.textAlignment = UITextAlignmentLeft;
    
    self.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
    [self.contentView addSubview:self.nameLabel];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.nameLabel.text = nil;
}

- (void)layoutSubviews {
  [super layoutSubviews];
}

+ (void)fillCell:(PersonCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image {
  cell.imageView.image = image;
  
  // NOTE: make sure not <null>
  cell.nameLabel.text = [dictionary valueForKey:@"name"];
}

+ (CGFloat)rowHeight {
  return 60.0;
}

- (void)dealloc {
  RELEASE_SAFELY(_nameLabel);
  [super dealloc];
}

@end
