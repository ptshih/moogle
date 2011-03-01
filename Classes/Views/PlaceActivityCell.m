//
//  PlaceActivityCell.m
//  Moogle
//
//  Created by Peter Shih on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceActivityCell.h"

#define CELL_FONT_SIZE 14.0
#define SPACING_X 4.0
#define SPACING_Y 4.0
#define LABEL_HEIGHT 17.0

@implementation PlaceActivityCell

@synthesize nameLabel = _nameLabel;
@synthesize timestampLabel = _timestampLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _nameLabel = [[UILabel alloc] init];
    _timestampLabel = [[UILabel alloc] init];
    
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.timestampLabel.backgroundColor = [UIColor clearColor];
    
    self.nameLabel.font = [UIFont boldSystemFontOfSize:CELL_FONT_SIZE];
    self.timestampLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
    
    self.nameLabel.textAlignment = UITextAlignmentLeft;
    self.timestampLabel.textAlignment = UITextAlignmentLeft;
    
    self.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.timestampLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timestampLabel];
  }
  
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.nameLabel.text = nil;
  self.timestampLabel.text = nil;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  // Image
  self.imageView.left = SPACING_X;
  self.imageView.top = SPACING_Y;
  self.imageView.width = 34.0;
  self.imageView.height = 34.0;
  
  _imageLoadingIndicator.frame = CGRectMake(11 + 5, 7 + 5, 20, 20);
  
  CGFloat left = SPACING_X;
  CGFloat textWidth = 0.0;
  CGSize textSize = CGSizeZero;
  CGSize labelSize = CGSizeZero;
  
  // Dynamically Space for Image
  //  if (self.imageView.image) {
  //    left = self.imageView.right + SPACING_X;
  //  }
  
  // Always leave space for image
  left = left + IMAGE_WIDTH + SPACING_X * 2;
  
  // Initial Y Positions
  self.nameLabel.top = SPACING_Y;
  self.timestampLabel.top = SPACING_Y + LABEL_HEIGHT;
  
  // Name
  textWidth = self.contentView.width - left - SPACING_X;
  textSize = CGSizeMake(textWidth, LABEL_HEIGHT);
  
  labelSize = [self.nameLabel.text sizeWithFont:self.nameLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.nameLabel.width = labelSize.width;
  self.nameLabel.height = labelSize.height;
  self.nameLabel.left = left;
  
  // Timestamp
  textWidth = self.contentView.width - left - SPACING_X;
  textSize = CGSizeMake(textWidth, LABEL_HEIGHT);
  
  labelSize = [self.timestampLabel.text sizeWithFont:self.timestampLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.timestampLabel.width = labelSize.width;
  self.timestampLabel.height = labelSize.height;
  self.timestampLabel.left = left;
}

+ (MoogleCellType)cellType {
  return MoogleCellTypeGrouped;
}

+ (void)fillCell:(PlaceActivityCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image {
  cell.imageView.image = image;
  
  cell.nameLabel.text = [dictionary valueForKey:@"place_name"];
  
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[dictionary valueForKey:@"timestamp"] integerValue]];
  
  cell.timestampLabel.text = [NSString stringWithFormat:@"Checked in here %@", [date humanIntervalSinceNow]];
  
}

+ (CGFloat)rowHeight {
  return 44.0;
}

- (void)dealloc {
  [super dealloc];
}

@end
