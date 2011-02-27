//
//  WhoCell.m
//  Moogle
//
//  Created by Peter Shih on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WhoCell.h"

#define CELL_FONT_SIZE 18.0
#define SPACING_X 7.0
#define SPACING_Y 12.0
#define LABEL_HEIGHT 20.0

@implementation WhoCell

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
  
  self.imageView.left = 7.0;
  self.imageView.top = 7.0;
  self.imageView.width = 30.0;
  self.imageView.height = 30.0;
  
  _imageLoadingIndicator.frame = CGRectMake(7 + 5, 7 + 5, 20, 20);
  
  CGFloat left = SPACING_X;
  CGFloat textWidth = self.contentView.width;
  CGSize textSize = CGSizeMake(textWidth, LABEL_HEIGHT);
  CGSize labelSize = CGSizeZero;
  
  // Dynamically Space for Image
  //  if (self.imageView.image) {
  //    left = self.imageView.right + SPACING_X;
  //  }
  
  // Always leave space for image
  left = left + 30 + SPACING_X;
  
  self.nameLabel.top = SPACING_Y;
  
  textWidth = self.contentView.width - left;
  textSize = CGSizeMake(textWidth, LABEL_HEIGHT);
  
  // Name
  labelSize = [self.nameLabel.text sizeWithFont:self.nameLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.nameLabel.width = labelSize.width;
  self.nameLabel.height = labelSize.height;
  self.nameLabel.left = left;
}

+ (void)fillCell:(WhoCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image {
  cell.imageView.image = image;
  
  // NOTE: make sure not <null>
  cell.nameLabel.text = [dictionary valueForKey:@"friend_name"];
}

+ (CGFloat)rowHeight {
  return 60.0;
}

- (void)dealloc {
  RELEASE_SAFELY(_nameLabel);
  [super dealloc];
}

@end
