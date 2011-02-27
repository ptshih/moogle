//
//  PlaceCell.m
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceCell.h"

#define CELL_FONT_SIZE 14.0
#define SPACING_X 4.0
#define SPACING_Y 4.0
#define LABEL_HEIGHT 17.0

@implementation PlaceCell

@synthesize nameLabel = _nameLabel;
@synthesize distanceLabel = _distanceLabel;
@synthesize countLabel = _countLabel;
@synthesize statsLabel = _statsLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _nameLabel = [[UILabel alloc] init];
    _distanceLabel = [[UILabel alloc] init];
    _countLabel = [[UILabel alloc] init];
    _statsLabel = [[UILabel alloc] init];
    
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.distanceLabel.backgroundColor = [UIColor clearColor];
    self.countLabel.backgroundColor = [UIColor clearColor];
    self.statsLabel.backgroundColor = [UIColor clearColor];
    
    self.nameLabel.font = [UIFont boldSystemFontOfSize:CELL_FONT_SIZE];
    self.distanceLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
    self.countLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
    self.statsLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
    
    self.nameLabel.textAlignment = UITextAlignmentLeft;
    self.distanceLabel.textAlignment = UITextAlignmentRight;
    self.countLabel.textAlignment = UITextAlignmentLeft;
    self.statsLabel.textAlignment = UITextAlignmentLeft;
    
    self.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.countLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.statsLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.distanceLabel];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.statsLabel];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.nameLabel.text = nil;
  self.distanceLabel.text = nil;
  self.countLabel.text = nil;
  self.statsLabel.text = nil;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
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
  
  self.nameLabel.top = SPACING_Y;
  self.distanceLabel.top = SPACING_Y;
  self.statsLabel.top = SPACING_Y  + LABEL_HEIGHT;
  self.countLabel.top = SPACING_Y  + LABEL_HEIGHT * 2;
  
  textWidth = self.contentView.width - left;
  textSize = CGSizeMake(textWidth, LABEL_HEIGHT);
  
  // Distance
  labelSize = [self.distanceLabel.text sizeWithFont:self.distanceLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.distanceLabel.width = labelSize.width;
  self.distanceLabel.height = labelSize.height;
  self.distanceLabel.left =  self.contentView.width - self.distanceLabel.width - SPACING_X;
  
  textWidth = self.contentView.width - left - self.distanceLabel.width - SPACING_X;
  textSize = CGSizeMake(textWidth, LABEL_HEIGHT);
  
  // Name
  labelSize = [self.nameLabel.text sizeWithFont:self.nameLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.nameLabel.width = labelSize.width;
  self.nameLabel.height = labelSize.height;
  self.nameLabel.left = left;
  
  textWidth = self.contentView.width - left;
  textSize = CGSizeMake(textWidth, LABEL_HEIGHT);
  
  // Stats
  labelSize = [self.statsLabel.text sizeWithFont:self.statsLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.statsLabel.width = labelSize.width;
  self.statsLabel.height = labelSize.height;
  self.statsLabel.left = left;
  
  textWidth = self.contentView.width - left;
  textSize = CGSizeMake(textWidth, LABEL_HEIGHT);
  
  labelSize = [self.countLabel.text sizeWithFont:self.countLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.countLabel.width = labelSize.width;
  self.countLabel.height = labelSize.height;
  self.countLabel.left = left;
}

+ (void)fillCell:(PlaceCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image {
  cell.imageView.image = image;
  
  // NOTE: make sure not <null>
  cell.nameLabel.text = [dictionary valueForKey:@"name"];
  cell.distanceLabel.text = [NSString stringWithFormat:@"%.2fmi", [[dictionary valueForKey:@"distance"] floatValue]];
  cell.statsLabel.text = [NSString stringWithFormat:@"A: %@, F: %@, L: %@", [dictionary valueForKey:@"checkins_count"], [dictionary valueForKey:@"checkins_friend_count"], [dictionary valueForKey:@"like_count"]];
  cell.countLabel.text = @"5 of your friends checked in here";
}

+ (CGFloat)rowHeight {
  return 60.0;
}

- (void)dealloc {
  RELEASE_SAFELY (_nameLabel);
  RELEASE_SAFELY (_distanceLabel);
  RELEASE_SAFELY (_countLabel);
  RELEASE_SAFELY(_statsLabel);
  [super dealloc];
}

@end
