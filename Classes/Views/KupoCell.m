//
//  KupoCell.m
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KupoCell.h"

#define NAME_FONT_SIZE 16.0
#define CELL_FONT_SIZE 14.0
#define SPACING_X 5.0
#define SPACING_Y 5.0
#define LABEL_HEIGHT 20.0
#define ICON_WIDTH 18.0
#define ICON_HEIGHT 18.0
#define ICON_SPACING 2.0

static UIImage *_placeIcon = nil;
static UIImage *_referIcon = nil;

@implementation KupoCell

@synthesize nameLabel = _nameLabel;
@synthesize placeNameLabel = _placeNameLabel;
@synthesize timestampLabel = _timestampLabel;
@synthesize referLabel = _referLabel;

+ (void)initialize {
  _placeIcon = [[UIImage imageNamed:@"cell_place_icon.png"] retain];
  _referIcon = [[UIImage imageNamed:@"cell_place_icon.png"] retain];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _nameLabel = [[UILabel alloc] init];
    _placeNameLabel = [[UILabel alloc] init];
    _timestampLabel = [[UILabel alloc] init];
    _referLabel = [[UILabel alloc] init];
    
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.placeNameLabel.backgroundColor = [UIColor clearColor];
    self.timestampLabel.backgroundColor = [UIColor clearColor];
    self.referLabel.backgroundColor = [UIColor clearColor];
    
    self.nameLabel.font = [UIFont boldSystemFontOfSize:NAME_FONT_SIZE];
    self.placeNameLabel.font = [UIFont boldSystemFontOfSize:CELL_FONT_SIZE];
    self.timestampLabel.font = [UIFont italicSystemFontOfSize:CELL_FONT_SIZE];
    self.referLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
    
    self.timestampLabel.textColor = GRAY_COLOR;
//    self.referLabel.textColor = FB_COLOR_DARK_BLUE;
    
    self.nameLabel.textAlignment = UITextAlignmentLeft;
    self.placeNameLabel.textAlignment = UITextAlignmentLeft;
    self.timestampLabel.textAlignment = UITextAlignmentLeft;
    self.referLabel.textAlignment = UITextAlignmentLeft;
    
    self.nameLabel.lineBreakMode = UILineBreakModeTailTruncation;
    self.placeNameLabel.lineBreakMode = UILineBreakModeTailTruncation;
    self.timestampLabel.lineBreakMode = UILineBreakModeTailTruncation;
    self.referLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    self.nameLabel.numberOfLines = 1;
    self.placeNameLabel.numberOfLines = 1;
    self.timestampLabel.numberOfLines = 1;
    self.referLabel.numberOfLines = 1;
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.placeNameLabel];
    [self.contentView addSubview:self.timestampLabel];
    [self.contentView addSubview:self.referLabel];
    
    _placeIconView = [[UIImageView alloc] initWithImage:_placeIcon];
    _referIconView = [[UIImageView alloc] initWithImage:_referIcon];
    
    [self.contentView addSubview:_placeIconView];
    [self.contentView addSubview:_referIconView];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.nameLabel.text = nil;
  self.placeNameLabel.text = nil;
  self.timestampLabel.text = nil;
  self.referLabel.text = nil;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat top = SPACING_Y;
  CGFloat left = IMAGE_WIDTH + SPACING_X * 2; // spacers: left of img, right of img, left of txt
  CGFloat textWidth = self.contentView.width - left - SPACING_X;
  CGSize textSize = CGSizeZero;
  CGSize labelSize = CGSizeZero;
  
  // Configure ImageView
  self.imageView.top = top;
  self.imageView.left = SPACING_X;
  
  // Configure Icons
  _placeIconView.top = self.imageView.bottom + SPACING_Y;
  _referIconView.top = _placeIconView.bottom + ICON_SPACING;
  _placeIconView.left = left;
  _referIconView.left = left;
  
  // Initial Label Y Positions
  self.nameLabel.top = top + 1.0;
  self.timestampLabel.top = top + LABEL_HEIGHT;
  self.placeNameLabel.top = _placeIconView.top;
  self.referLabel.top = _referIconView.top;
  
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
  left += ICON_HEIGHT + SPACING_X *2;
  textWidth = textWidth - ICON_WIDTH - SPACING_X *2;
  textSize = CGSizeMake(textWidth, LABEL_HEIGHT);
  
  // Place Name
  labelSize = [self.placeNameLabel.text sizeWithFont:self.placeNameLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.placeNameLabel.width = labelSize.width;
  self.placeNameLabel.height = labelSize.height;
  self.placeNameLabel.left = left;

  // Referral
  labelSize = [self.referLabel.text sizeWithFont:self.referLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.referLabel.width = labelSize.width;
  self.referLabel.height = labelSize.height;
  self.referLabel.left = left;
}

+ (void)fillCell:(KupoCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image {
  cell.imageView.image = image;
  
  NSDate *checkinDate = [NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:@"checkin_time"] integerValue]];
  NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:@"your_last_checkin_time"] integerValue]];
  
  cell.nameLabel.text = [dictionary valueForKey:@"user_name"];
  cell.placeNameLabel.text = [dictionary valueForKey:@"place_name"];
  cell.timestampLabel.text = [NSString stringWithFormat:@"%@ via %@", [checkinDate humanIntervalSinceNow], @"Moogle"];
  cell.referLabel.text = [NSString stringWithFormat:@"You last checked in %@", [lastDate humanIntervalSinceNow]];
}

+ (CGFloat)rowHeight {
  return 95 + ICON_SPACING;
}

- (void)dealloc {
  RELEASE_SAFELY (_nameLabel);
  RELEASE_SAFELY (_placeNameLabel);
  RELEASE_SAFELY (_timestampLabel);
  RELEASE_SAFELY(_referLabel);
  RELEASE_SAFELY(_placeIconView);
  RELEASE_SAFELY(_referIconView);
  [super dealloc];
}

@end
