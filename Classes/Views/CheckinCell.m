//
//  CheckinCell.m
//  Moogle
//
//  Created by Peter Shih on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CheckinCell.h"

#define CELL_FONT_SIZE 14.0
#define SPACING_X 4.0
#define SPACING_Y 4.0
#define LABEL_HEIGHT 17.0

@implementation CheckinCell

@synthesize nameLabel = _nameLabel;
@synthesize placeNameLabel = _placeNameLabel;
@synthesize timestampLabel = _timestampLabel;
@synthesize countLabel = _countLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _nameLabel = [[UILabel alloc] init];
    _placeNameLabel = [[UILabel alloc] init];
    _timestampLabel = [[UILabel alloc] init];
    _countLabel = [[UILabel alloc] init];
    
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.placeNameLabel.backgroundColor = [UIColor clearColor];
    self.timestampLabel.backgroundColor = [UIColor clearColor];
    self.countLabel.backgroundColor = [UIColor clearColor];
    
    self.nameLabel.font = [UIFont boldSystemFontOfSize:CELL_FONT_SIZE];
    self.placeNameLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
    self.timestampLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
    self.countLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
    
    self.nameLabel.textAlignment = UITextAlignmentLeft;
    self.placeNameLabel.textAlignment = UITextAlignmentLeft;
    self.countLabel.textAlignment = UITextAlignmentLeft;
    self.timestampLabel.textAlignment = UITextAlignmentRight;
    
    self.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.placeNameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.countLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
//    self.timestampLabel.autoresizingMask = 
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.placeNameLabel];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.timestampLabel];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.nameLabel.text = nil;
  self.placeNameLabel.text = nil;
  self.countLabel.text = nil;
  self.timestampLabel.text = nil;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat left = SPACING_X;
  CGFloat textWidth = self.contentView.width;
  CGSize textSize = CGSizeMake(textWidth, LABEL_HEIGHT);
  CGSize labelSize = CGSizeZero;
  
  // Dynamically Space for Image
//  if (self.imageView.image) {
//    left = self.imageView.right + SPACING_X;
//  }
  
  // Always leave space for image
  left = left + IMAGE_WIDTH + SPACING_X * 2;
  
  // Initial Y Positions
  self.nameLabel.top = SPACING_Y;
  self.placeNameLabel.top = SPACING_Y + LABEL_HEIGHT;
  self.countLabel.top = SPACING_Y + LABEL_HEIGHT * 2;
  self.timestampLabel.top = SPACING_Y;
  
  
  // Timestamp
  textWidth = self.contentView.width - left;
  textSize = CGSizeMake(textWidth, LABEL_HEIGHT);
  
  labelSize = [self.timestampLabel.text sizeWithFont:self.timestampLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.timestampLabel.width = labelSize.width;
  self.timestampLabel.height = labelSize.height;
  self.timestampLabel.left = self.contentView.width - self.timestampLabel.width - SPACING_X;
  
  // Name
  textWidth = self.contentView.width - left - self.timestampLabel.width - SPACING_X;
  textSize = CGSizeMake(textWidth, LABEL_HEIGHT);
  
  labelSize = [self.nameLabel.text sizeWithFont:self.nameLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.nameLabel.width = labelSize.width;
  self.nameLabel.height = labelSize.height;
  self.nameLabel.left = left;
  
  // Place Name
  textWidth = self.contentView.width - left;
  textSize = CGSizeMake(textWidth, LABEL_HEIGHT);
  
  labelSize = [self.placeNameLabel.text sizeWithFont:self.placeNameLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.placeNameLabel.width = labelSize.width;
  self.placeNameLabel.height = labelSize.height;
  self.placeNameLabel.left = left;
  
  // Checkin Count
  textWidth = self.contentView.width - left;
  textSize = CGSizeMake(textWidth, LABEL_HEIGHT);
  
  labelSize = [self.countLabel.text sizeWithFont:self.countLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.countLabel.width = labelSize.width;
  self.countLabel.height = labelSize.height;
  self.countLabel.left =  left;
}

+ (void)fillCell:(CheckinCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image {
  cell.imageView.image = image;
  
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:@"checkin_timestamp"] integerValue]];
  
  cell.nameLabel.text = [dictionary objectForKey:@"name"];
  cell.placeNameLabel.text = [dictionary objectForKey:@"place_name"];
  cell.countLabel.text = @"5 friends also checked in here";
  cell.timestampLabel.text = [date humanIntervalSinceNow];
}

+ (CGFloat)rowHeight {
  return 60.0;
}

- (void)dealloc {
  RELEASE_SAFELY (_nameLabel);
  RELEASE_SAFELY (_placeNameLabel);
  RELEASE_SAFELY (_timestampLabel);
  RELEASE_SAFELY (_countLabel);
  [super dealloc];
}

@end