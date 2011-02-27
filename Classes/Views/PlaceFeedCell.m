//
//  PlaceFeedCell.m
//  Moogle
//
//  Created by Peter Shih on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceFeedCell.h"

#define CELL_FONT_SIZE 14.0
#define SPACING_X 4.0
#define SPACING_Y 4.0
#define LABEL_HEIGHT 17.0

@implementation PlaceFeedCell

@synthesize nameLabel = _nameLabel;
@synthesize messageLabel = _messageLabel;
@synthesize timestampLabel = _timestampLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _nameLabel = [[UILabel alloc] init];
    _messageLabel = [[UILabel alloc] init];
    _timestampLabel = [[UILabel alloc] init];
    
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.timestampLabel.backgroundColor = [UIColor clearColor];
    
    self.nameLabel.font = [UIFont boldSystemFontOfSize:CELL_FONT_SIZE];
    self.messageLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
    self.timestampLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
    
    self.nameLabel.textAlignment = UITextAlignmentLeft;
    self.messageLabel.textAlignment = UITextAlignmentLeft;
    self.timestampLabel.textAlignment = UITextAlignmentRight;
    
    self.messageLabel.numberOfLines = 100;
    
    self.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.messageLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;

    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addSubview:self.timestampLabel];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.nameLabel.text = nil;
  self.messageLabel.text = nil;
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
  self.messageLabel.top = SPACING_Y + LABEL_HEIGHT;
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
  
  // Message
  textWidth = self.contentView.width - left;
  textSize = CGSizeMake(textWidth, INT_MAX);
  
  labelSize = [self.messageLabel.text sizeWithFont:self.nameLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
  self.messageLabel.width = labelSize.width;
  self.messageLabel.height = labelSize.height;
  self.messageLabel.left = left;
  
  // Set desired variable height
  _desiredHeight = self.messageLabel.bottom + SPACING_Y;
}

+ (void)fillCell:(PlaceFeedCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image {
  cell.imageView.image = image;
  
  cell.nameLabel = [dictionary objectForKey:@"from"];
  cell.messageLabel = [dictionary objectForKey:@"message"];
}

+ (CGFloat)variableRowHeightForCell:(id)cell {
  return [cell desiredHeight];
}

- (void)dealloc {
  RELEASE_SAFELY(_nameLabel);
  RELEASE_SAFELY(_messageLabel);
  RELEASE_SAFELY(_timestampLabel);
  [super dealloc];
}

@end
