//
//  CheckinCell.m
//  Moogle
//
//  Created by Peter Shih on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CheckinCell.h"

#define NAME_FONT_SIZE 16.0
#define CELL_FONT_SIZE 14.0
#define SPACING_X 5.0
#define SPACING_Y 5.0
#define LABEL_HEIGHT 20.0
#define CELL_WIDTH 320.0
#define ICON_WIDTH 18.0
#define ICON_HEIGHT 18.0
#define ICON_SPACING 2.0

static UIImage *_placeIcon = nil;
static UIImage *_messageIcon = nil;
static UIImage *_taggedIcon = nil;

@implementation CheckinCell

@synthesize nameLabel = _nameLabel;
@synthesize placeNameLabel = _placeNameLabel;
@synthesize timestampLabel = _timestampLabel;
@synthesize messageLabel = _messageLabel;
@synthesize taggedLabel = _taggedLabel;

+ (void)initialize {
  _placeIcon = [[UIImage imageNamed:@"cell_place_icon.png"] retain];
  _messageIcon = [[UIImage imageNamed:@"cell_place_icon.png"] retain];
  _taggedIcon = [[UIImage imageNamed:@"cell_place_icon.png"] retain];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _nameLabel = [[UILabel alloc] init];
    _placeNameLabel = [[UILabel alloc] init];
    _timestampLabel = [[UILabel alloc] init];
    _messageLabel = [[UILabel alloc] init];
    _taggedLabel = [[UILabel alloc] init];
    
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.placeNameLabel.backgroundColor = [UIColor clearColor];
    self.timestampLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.taggedLabel.backgroundColor = [UIColor clearColor];
    
    self.nameLabel.font = [UIFont boldSystemFontOfSize:NAME_FONT_SIZE];
    self.placeNameLabel.font = [UIFont boldSystemFontOfSize:CELL_FONT_SIZE];
    self.timestampLabel.font = [UIFont italicSystemFontOfSize:CELL_FONT_SIZE];
    self.messageLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
    self.taggedLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
    
    self.timestampLabel.textColor = GRAY_COLOR;
    
    self.nameLabel.textAlignment = UITextAlignmentLeft;
    self.placeNameLabel.textAlignment = UITextAlignmentLeft;
    self.timestampLabel.textAlignment = UITextAlignmentLeft;
    self.messageLabel.textAlignment = UITextAlignmentLeft;
    self.taggedLabel.textAlignment = UITextAlignmentLeft;
    
    self.nameLabel.lineBreakMode = UILineBreakModeTailTruncation;
    self.placeNameLabel.lineBreakMode = UILineBreakModeTailTruncation;
    self.timestampLabel.lineBreakMode = UILineBreakModeTailTruncation;
    self.messageLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.taggedLabel.lineBreakMode = UILineBreakModeWordWrap; // multi-line
    
    self.nameLabel.numberOfLines = 1;
    self.placeNameLabel.numberOfLines = 1;
    self.timestampLabel.numberOfLines = 1;
    self.messageLabel.numberOfLines = 10;
    self.taggedLabel.numberOfLines = 10;
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.placeNameLabel];
    [self.contentView addSubview:self.timestampLabel];
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addSubview:self.taggedLabel];
    
    _placeIconView = [[UIImageView alloc] initWithImage:_placeIcon];
    _messageIconView = [[UIImageView alloc] initWithImage:_placeIcon];
    _taggedIconView = [[UIImageView alloc] initWithImage:_placeIcon];
    
    [self.contentView addSubview:_placeIconView];
    [self.contentView addSubview:_messageIconView];
    [self.contentView addSubview:_taggedIconView];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.nameLabel.text = nil;
  self.placeNameLabel.text = nil;
  self.timestampLabel.text = nil;
  self.messageLabel.text = nil;
  self.taggedLabel.text = nil;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat top = SPACING_Y;
  CGFloat left = IMAGE_WIDTH + SPACING_X * 3; // spacers: left of img, right of img, left of txt
  CGFloat textWidth = self.contentView.width - left - SPACING_X;
  CGSize textSize = CGSizeZero;
  CGSize labelSize = CGSizeZero;
  
  // Configure ImageView
  self.imageView.top = top;
  self.imageView.left = SPACING_X;
  
  // Configure Icons
  _placeIconView.top = self.imageView.bottom + SPACING_Y;
  _messageIconView.top = _placeIconView.bottom + ICON_SPACING;
  if ([self.messageLabel.text length] > 0) {
    _taggedIconView.top = _messageIconView.bottom + ICON_SPACING;
  } else {
    _taggedIconView.top = _placeIconView.bottom + ICON_SPACING;
  }
  _placeIconView.left = left;
  _messageIconView.left = left;
  _taggedIconView.left = left;
  
  // Initial Label Y Positions
  self.nameLabel.top = top + 1.0;
  self.timestampLabel.top = top + LABEL_HEIGHT;
  self.placeNameLabel.top = _placeIconView.top;
  self.messageLabel.top = _messageIconView.top;
  self.taggedLabel.top = _taggedIconView.top;
  
  /**
   Setup all the labels
   */
  
  // Text size for all labels except taggedLabel (which is variable height)
  textSize = CGSizeMake(textWidth, LABEL_HEIGHT);
  
  // Name
  labelSize = [self.nameLabel.text sizeWithFont:self.nameLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.nameLabel.width = labelSize.width;
  self.nameLabel.height = labelSize.height;
  self.nameLabel.left = left;
  
  // Timestamp  
  labelSize = [self.timestampLabel.text sizeWithFont:self.timestampLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.timestampLabel.width = labelSize.width;
  self.timestampLabel.height = labelSize.height;
  self.timestampLabel.left = left;
  
  // Shift over right
  left += ICON_WIDTH + SPACING_X;
  textWidth = textWidth - ICON_WIDTH - SPACING_X;
  textSize = CGSizeMake(textWidth, LABEL_HEIGHT);
  
  // Place Name
  labelSize = [self.placeNameLabel.text sizeWithFont:self.placeNameLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.placeNameLabel.width = labelSize.width;
  self.placeNameLabel.height = labelSize.height;
  self.placeNameLabel.left = left;
  
  // Message
  if ([self.messageLabel.text length] > 0) {
    _messageIconView.hidden = NO;
    textSize = CGSizeMake(textWidth, INT_MAX); // Variable height
    labelSize = [self.messageLabel.text sizeWithFont:self.messageLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
    self.messageLabel.width = labelSize.width;
    self.messageLabel.height = labelSize.height;
    self.messageLabel.left =  left;
  } else {
    _messageIconView.hidden = YES;
  }
  
  // Tagged Users
  if ([self.taggedLabel.text length] > 0) {
    _taggedIconView.hidden = NO;
    textSize = CGSizeMake(textWidth, INT_MAX); // Variable height
    labelSize = [self.taggedLabel.text sizeWithFont:self.taggedLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
    self.taggedLabel.width = labelSize.width;
    self.taggedLabel.height = labelSize.height;
    self.taggedLabel.left =  left;
  } else {
    _taggedIconView.hidden = YES;
  }
}

+ (void)fillCell:(CheckinCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image {
  cell.imageView.image = image;
  
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:@"checkin_timestamp"] integerValue]];
  
  cell.nameLabel.text = [dictionary valueForKey:@"name"];
  cell.placeNameLabel.text = [dictionary valueForKey:@"place_name"];
  cell.messageLabel.text = [dictionary valueForKey:@"message"];
  cell.timestampLabel.text = [NSString stringWithFormat:@"%@ via %@", [date humanIntervalSinceNow], @"Moogle"];
  cell.taggedLabel.text = [[dictionary valueForKey:@"tagged_user_array"] componentsJoinedByString:@", "];
//  cell.taggedLabel.text = @"Peter Shih, James Liu, Thomas Liou, Gene Tsai, Nathan Bohannon";
}

+ (MoogleCellType)cellType {
  return MoogleCellTypePlain;
}

+ (CGFloat)variableRowHeightWithDictionary:(NSDictionary *)dictionary {
  CGFloat calculatedHeight = SPACING_Y; // Top Spacer
  CGFloat left = IMAGE_WIDTH + ICON_WIDTH + SPACING_X * 3;
  CGFloat textWidth = CELL_WIDTH - left - SPACING_X;
  CGSize textSize = CGSizeMake(textWidth, INT_MAX); // Variable height
  CGSize labelSize = CGSizeZero;
  
  // The rest (Static)
  calculatedHeight += 65;
  
  // Icon Spacing
  calculatedHeight += ICON_SPACING * 2;
  
  // Message String (Variable Height)
  labelSize = [[dictionary valueForKey:@"message"] sizeWithFont:[UIFont systemFontOfSize:CELL_FONT_SIZE] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
  calculatedHeight = calculatedHeight + labelSize.height;
  
  // Tagged String (Variable Height)
  NSString *taggedString = [[dictionary valueForKey:@"tagged_user_array"] componentsJoinedByString:@", "];
//  NSString *taggedString = @"Peter Shih, James Liu, Thomas Liou, Gene Tsai, Nathan Bohannon";
  labelSize = [taggedString sizeWithFont:[UIFont systemFontOfSize:CELL_FONT_SIZE] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
  calculatedHeight = calculatedHeight + labelSize.height;
  
  // Bottom Spacer
  calculatedHeight += SPACING_Y; // This is spacing*2 because its for top AND bottom
  
  return calculatedHeight;
}

- (void)dealloc {
  RELEASE_SAFELY (_nameLabel);
  RELEASE_SAFELY (_placeNameLabel);
  RELEASE_SAFELY (_timestampLabel);
  RELEASE_SAFELY (_messageLabel);
  RELEASE_SAFELY(_taggedLabel);
  RELEASE_SAFELY(_placeIconView);
  RELEASE_SAFELY(_messageIconView);
  RELEASE_SAFELY(_taggedIconView);
  [super dealloc];
}

@end