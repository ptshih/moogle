//
//  CheckinCell.m
//  Moogle
//
//  Created by Peter Shih on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CheckinCell.h"
#import "Checkin.h"
#import "Place.h"

#define NAME_FONT_SIZE 13.0
#define CELL_FONT_SIZE 13.0
#define LABEL_HEIGHT 15.0
#define CELL_WIDTH 320.0
#define ICON_WIDTH 13.0
#define ICON_HEIGHT 13.0
#define ICON_SPACING 4.0

static UIImage *_placeIcon = nil;
static UIImage *_taggedIcon = nil;
static UIImage *_likeIcon = nil;

@implementation CheckinCell

@synthesize nameLabel = _nameLabel;
@synthesize placeNameLabel = _placeNameLabel;
@synthesize timestampLabel = _timestampLabel;
@synthesize taggedLabel = _taggedLabel;
@synthesize messageLabel = _messageLabel;
@synthesize likesCommentsLabel = _likesCommentsLabel;

+ (void)initialize {
  _placeIcon = [[UIImage imageNamed:@"icon-place.png"] retain];
  _taggedIcon = [[UIImage imageNamed:@"icon-friends.png"] retain];
  _likeIcon = [[UIImage imageNamed:@"icon-like.png"] retain];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _nameLabel = [[UILabel alloc] init];
    _placeNameLabel = [[UILabel alloc] init];
    _timestampLabel = [[UILabel alloc] init];
    _taggedLabel = [[UILabel alloc] init];
    _messageLabel = [[UILabel alloc] init];
    _likesCommentsLabel = [[UILabel alloc] init];
    
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.placeNameLabel.backgroundColor = [UIColor clearColor];
    self.timestampLabel.backgroundColor = [UIColor clearColor];
    self.taggedLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.likesCommentsLabel.backgroundColor = [UIColor clearColor];
    
    self.nameLabel.font = [UIFont boldSystemFontOfSize:NAME_FONT_SIZE];
    self.placeNameLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
    self.timestampLabel.font = [UIFont italicSystemFontOfSize:CELL_FONT_SIZE];
    self.taggedLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
    self.messageLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
    self.likesCommentsLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
    
    self.timestampLabel.textColor = GRAY_COLOR;
    
    self.nameLabel.textAlignment = UITextAlignmentLeft;
    self.placeNameLabel.textAlignment = UITextAlignmentLeft;
    self.timestampLabel.textAlignment = UITextAlignmentRight;
    self.taggedLabel.textAlignment = UITextAlignmentLeft;
    self.messageLabel.textAlignment = UITextAlignmentLeft;
    self.likesCommentsLabel.textAlignment = UITextAlignmentLeft;
    
    self.nameLabel.lineBreakMode = UILineBreakModeTailTruncation;
    self.placeNameLabel.lineBreakMode = UILineBreakModeTailTruncation;
    self.timestampLabel.lineBreakMode = UILineBreakModeTailTruncation;
    self.taggedLabel.lineBreakMode = UILineBreakModeWordWrap; // multi-line
    self.messageLabel.lineBreakMode = UILineBreakModeWordWrap; // multi-line
    self.likesCommentsLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    self.nameLabel.numberOfLines = 1;
    self.placeNameLabel.numberOfLines = 1;
    self.timestampLabel.numberOfLines = 1;
    self.taggedLabel.numberOfLines = 10;
    self.messageLabel.numberOfLines = 10;
    self.likesCommentsLabel.numberOfLines = 1;
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.placeNameLabel];
    [self.contentView addSubview:self.timestampLabel];
    [self.contentView addSubview:self.taggedLabel];
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addSubview:self.likesCommentsLabel];
    
    _placeIconView = [[UIImageView alloc] initWithImage:_placeIcon];
    _taggedIconView = [[UIImageView alloc] initWithImage:_taggedIcon];
    _likeIconView = [[UIImageView alloc] initWithImage:_likeIcon];
    
    [self.contentView addSubview:_placeIconView];
    [self.contentView addSubview:_taggedIconView];
    [self.contentView addSubview:_likeIconView];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.nameLabel.text = nil;
  self.placeNameLabel.text = nil;
  self.timestampLabel.text = nil;
  self.taggedLabel.text = nil;
  self.messageLabel.text = nil;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat top = SPACING_Y;
  CGFloat left = IMAGE_WIDTH_PLAIN + SPACING_X * 2; // spacers: left of img, right of img
  CGFloat textWidth = self.contentView.width - left - SPACING_X;
  CGSize textSize = CGSizeZero;
  CGSize labelSize = CGSizeZero;
  
  // Configure Icons
  _placeIconView.left = left;
  _taggedIconView.left = left;
  _likeIconView.left = left;

  
  // Initial Label Y Positions
  self.nameLabel.top = top;
  
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
  textSize = CGSizeMake(textWidth - self.nameLabel.width - SPACING_X, LABEL_HEIGHT);
  self.timestampLabel.top = top;
  
  labelSize = [self.timestampLabel.text sizeWithFont:self.timestampLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.timestampLabel.width = labelSize.width;
  self.timestampLabel.height = labelSize.height;
  self.timestampLabel.left = self.contentView.width - self.timestampLabel.width - SPACING_X;
  
  // Shift over right
  left += ICON_WIDTH + SPACING_X;
  textWidth = textWidth - ICON_WIDTH - SPACING_X;
  textSize = CGSizeMake(textWidth, LABEL_HEIGHT);
  
  // Place Name
  _placeIconView.top = self.nameLabel.bottom + ICON_SPACING;
  self.placeNameLabel.top = _placeIconView.top;
  
  labelSize = [self.placeNameLabel.text sizeWithFont:self.placeNameLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.placeNameLabel.width = labelSize.width;
  self.placeNameLabel.height = labelSize.height;
  self.placeNameLabel.left = left + ICON_SPACING;
  
  // Likes Commemts
  _likeIconView.top = self.placeNameLabel.bottom + ICON_SPACING;
  self.likesCommentsLabel.top = _likeIconView.top;
  
  if ([self.likesCommentsLabel.text length] > 0) {
    _likeIconView.hidden = NO;
    labelSize = [self.likesCommentsLabel.text sizeWithFont:self.likesCommentsLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
    self.likesCommentsLabel.width = labelSize.width;
    self.likesCommentsLabel.height = labelSize.height;
    self.likesCommentsLabel.left = left + ICON_SPACING;
  } else {
    _likeIconView.hidden = YES;
  }
  
  // Tagged Users
  _taggedIconView.top = self.likesCommentsLabel.bottom + ICON_SPACING;
  self.taggedLabel.top = _taggedIconView.top;
  
  if ([self.taggedLabel.text length] > 0) {
    _taggedIconView.hidden = NO;
    textSize = CGSizeMake(textWidth, INT_MAX); // Variable height
    labelSize = [self.taggedLabel.text sizeWithFont:self.taggedLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
    self.taggedLabel.width = labelSize.width;
    self.taggedLabel.height = labelSize.height;
    self.taggedLabel.left =  left + ICON_SPACING;
  } else {
    _taggedIconView.hidden = YES;
  }
  
  // Message
  if ([self.taggedLabel.text length] > 0) {
    self.messageLabel.top = self.taggedLabel.bottom + ICON_SPACING;
  } else {
    self.messageLabel.top = self.likesCommentsLabel.bottom + ICON_SPACING;
  }

  
  if ([self.messageLabel.text length] > 0) {
    textSize = CGSizeMake(textWidth, INT_MAX); // Variable height
    labelSize = [self.messageLabel.text sizeWithFont:self.messageLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
    self.messageLabel.width = labelSize.width;
    self.messageLabel.height = labelSize.height;
    self.messageLabel.left =  left - ICON_WIDTH - ICON_SPACING;
  } else {
  }
}

+ (void)fillCell:(CheckinCell *)cell withCheckin:(Checkin *)checkin withImage:(UIImage *)image {
  cell.smaImageView.urlPath = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", checkin.facebookId];
  
  [cell.smaImageView loadImageIfCached];
  
  cell.nameLabel.text = checkin.facebookName;
  cell.placeNameLabel.text = checkin.place.placeName;
  cell.timestampLabel.text = [checkin.checkinDate humanIntervalSinceNow];
  cell.taggedLabel.text = [checkin.checkinTagsArray componentsJoinedByString:@", "];
  cell.messageLabel.text = checkin.checkinMessage;
  cell.likesCommentsLabel.text = [NSString stringWithFormat:@"%d likes, %d comments", [checkin.checkinLikesArray count], [checkin.checkinCommentsArray count]];
}

+ (MoogleCellType)cellType {
  return MoogleCellTypePlain;
}

+ (CGFloat)variableRowHeightWithCheckin:(Checkin *)checkin {
  CGFloat calculatedHeight = SPACING_Y; // Top Spacer
  CGFloat left = IMAGE_WIDTH_PLAIN + ICON_WIDTH + SPACING_X * 3;
  CGFloat textWidth = CELL_WIDTH - left - SPACING_X;
  CGSize textSize = CGSizeMake(textWidth, INT_MAX); // Variable height
  CGSize labelSize = CGSizeZero;
  
  // Name
  calculatedHeight += LABEL_HEIGHT + ICON_SPACING;
  
  // Place
  calculatedHeight += LABEL_HEIGHT + ICON_SPACING;
  
  // Likes/Comments
//  if (([checkin.checkinLikesArray count] > 0) || ([checkin.checkinCommentsArray count] > 0)) {
    calculatedHeight += LABEL_HEIGHT + ICON_SPACING;
//  }
  
  // Tagged String (Variable Height)
  if ([checkin.checkinTagsArray count] > 0) {
  NSString *taggedString = [checkin.checkinTagsArray componentsJoinedByString:@", "];
//  NSString *taggedString = @"Peter Shih, James Liu, Thomas Liou, Gene Tsai, Nathan Bohannon";
    labelSize = [taggedString sizeWithFont:[UIFont systemFontOfSize:CELL_FONT_SIZE] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
    calculatedHeight += labelSize.height + ICON_SPACING;
  }
  
  // Message String (Variable Height)
  if (checkin.checkinMessage) {
    labelSize = [checkin.checkinMessage sizeWithFont:[UIFont systemFontOfSize:CELL_FONT_SIZE] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
    calculatedHeight += labelSize.height + ICON_SPACING;
  }
  
  // Bottom Spacer
  calculatedHeight += SPACING_Y; // This is spacing*2 because its for top AND bottom
  
  // If height is less than image, adjust
  if (calculatedHeight < IMAGE_HEIGHT_PLAIN + (SPACING_Y * 2)) {
    calculatedHeight = IMAGE_HEIGHT_PLAIN + (SPACING_Y * 2);
  }
  
  return calculatedHeight;
}

- (void)dealloc {
  RELEASE_SAFELY (_nameLabel);
  RELEASE_SAFELY (_placeNameLabel);
  RELEASE_SAFELY (_timestampLabel);
  RELEASE_SAFELY(_taggedLabel);
  RELEASE_SAFELY (_messageLabel);
  RELEASE_SAFELY(_likesCommentsLabel);
  RELEASE_SAFELY(_placeIconView);
  RELEASE_SAFELY(_taggedIconView);
  RELEASE_SAFELY(_likeIconView);
  [super dealloc];
}

@end