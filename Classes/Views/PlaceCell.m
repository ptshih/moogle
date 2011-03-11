//
//  PlaceCell.m
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceCell.h"
#import "Place.h"

#define NAME_FONT_SIZE 13.0
#define CELL_FONT_SIZE 13.0
#define LABEL_HEIGHT 15.0
#define CELL_WIDTH 320.0
#define ICON_WIDTH 13.0
#define ICON_HEIGHT 13.0
#define ICON_SPACING 4.0

static UIImage *_likesIcon = nil;
static UIImage *_countIcon = nil;
static UIImage *_totalIcon = nil;
static UIImage *_distanceIcon = nil;

@implementation PlaceCell

@synthesize nameLabel = _nameLabel;
@synthesize distanceLabel = _distanceLabel;
@synthesize countLabel = _countLabel;
@synthesize totalLabel = _totalLabel;
@synthesize likesLabel = _likesLabel;

+ (void)initialize {
  _likesIcon = [[UIImage imageNamed:@"icon-like.png"] retain];
  _countIcon = [[UIImage imageNamed:@"icon-friends.png"] retain];
  _totalIcon = [[UIImage imageNamed:@"icon-checkin.png"] retain];
  _distanceIcon = [[UIImage imageNamed:@"icon-distance.png"] retain];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _nameLabel = [[UILabel alloc] init];
    _distanceLabel = [[UILabel alloc] init];
    _countLabel = [[UILabel alloc] init];
    _totalLabel = [[UILabel alloc] init];
    _likesLabel = [[UILabel alloc] init];
    
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.distanceLabel.backgroundColor = [UIColor clearColor];
    self.countLabel.backgroundColor = [UIColor clearColor];
    self.totalLabel.backgroundColor = [UIColor clearColor];
    self.likesLabel.backgroundColor = [UIColor clearColor];
    
    self.nameLabel.font = [UIFont boldSystemFontOfSize:NAME_FONT_SIZE];
    self.distanceLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
    self.countLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
    self.totalLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
    self.likesLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
    
    self.nameLabel.textAlignment = UITextAlignmentLeft;
    self.distanceLabel.textAlignment = UITextAlignmentLeft;
    self.countLabel.textAlignment = UITextAlignmentLeft;
    self.totalLabel.textAlignment = UITextAlignmentLeft;
    self.likesLabel.textAlignment = UITextAlignmentLeft;
    
    self.nameLabel.lineBreakMode = UILineBreakModeTailTruncation;
    self.distanceLabel.lineBreakMode = UILineBreakModeTailTruncation;
    self.countLabel.lineBreakMode = UILineBreakModeTailTruncation;
    self.totalLabel.lineBreakMode = UILineBreakModeTailTruncation;
    self.likesLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    self.nameLabel.numberOfLines = 1;
    self.distanceLabel.numberOfLines = 1;
    self.countLabel.numberOfLines = 1;
    self.totalLabel.numberOfLines = 1;
    self.likesLabel.numberOfLines = 1;
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.distanceLabel];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.totalLabel];
    [self.contentView addSubview:self.likesLabel];
    
    _likesIconView = [[UIImageView alloc] initWithImage:_likesIcon];
    _countIconView = [[UIImageView alloc] initWithImage:_countIcon];
    _totalIconView = [[UIImageView alloc] initWithImage:_totalIcon];
    _distanceIconView = [[UIImageView alloc] initWithImage:_distanceIcon];
    
    [self.contentView addSubview:_likesIconView];
    [self.contentView addSubview:_countIconView];
    [self.contentView addSubview:_totalIconView];
    [self.contentView addSubview:_distanceIconView];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.nameLabel.text = nil;
  self.distanceLabel.text = nil;
  self.countLabel.text = nil;
  self.totalLabel.text = nil;
  self.likesLabel.text = nil;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat top = SPACING_Y;
  CGFloat left = IMAGE_WIDTH_PLAIN + SPACING_X * 2; // spacers: left of img, right of img
  CGFloat textWidth = self.contentView.width - left - SPACING_X;
  CGSize textSize = CGSizeZero;
  CGSize labelSize = CGSizeZero;
  
  // Text size for all labels except taggedLabel (which is variable height)
  textSize = CGSizeMake(textWidth, LABEL_HEIGHT);
  
  // Name
  self.nameLabel.top = top;
  labelSize = [self.nameLabel.text sizeWithFont:self.nameLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.nameLabel.width = labelSize.width;
  self.nameLabel.height = labelSize.height;
  self.nameLabel.left = left;
  
  
  // Icons
  _distanceIconView.top = self.nameLabel.bottom + ICON_SPACING;
  _likesIconView.top = self.nameLabel.bottom + ICON_SPACING;
  _totalIconView.top = _distanceIconView.bottom + ICON_SPACING;
  _countIconView.top = _likesIconView.bottom + ICON_SPACING;
  
  _distanceIconView.left = left;
  _totalIconView.left = left;
  _likesIconView.left = _distanceIconView.right + ((self.contentView.width - SPACING_X - _distanceIconView.right) / 2);
  _countIconView.left = _totalIconView.right + ((self.contentView.width - SPACING_X - _totalIconView.right) / 2);
  
  // Initial Label Y Positions

  self.distanceLabel.top = _distanceIconView.top;
  self.likesLabel.top = _likesIconView.top;
  self.totalLabel.top = _totalIconView.top;
  self.countLabel.top = _countIconView.top;
  
  /**
   Setup all the labels
   */


  // Distance
  labelSize = [self.distanceLabel.text sizeWithFont:self.distanceLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.distanceLabel.width = labelSize.width;
  self.distanceLabel.height = labelSize.height;
  self.distanceLabel.left = _distanceIconView.right + SPACING_X;
  
  // Likes
  labelSize = [self.likesLabel.text sizeWithFont:self.likesLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.likesLabel.width = labelSize.width;
  self.likesLabel.height = labelSize.height;
  self.likesLabel.left = _likesIconView.right + SPACING_X;
  
  // Total
  labelSize = [self.totalLabel.text sizeWithFont:self.totalLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.totalLabel.width = labelSize.width;
  self.totalLabel.height = labelSize.height;
  self.totalLabel.left = _totalIconView.right + SPACING_X;
  
  // Count
  labelSize = [self.countLabel.text sizeWithFont:self.countLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.countLabel.width = labelSize.width;
  self.countLabel.height = labelSize.height;
  self.countLabel.left = _countIconView.right + SPACING_X;
}

+ (void)fillCell:(PlaceCell *)cell withPlace:(Place *)place withImage:(UIImage *)image {
  cell.smaImageView.urlPath = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", place.placeId];
  
  [cell.smaImageView loadImageIfCached];
  
  cell.nameLabel.text = place.placeName;
  cell.distanceLabel.text = [NSString stringWithFormat:@"%.2f miles", [place.placeDistance floatValue]];
  cell.likesLabel.text = [NSString stringWithFormat:@"%@ likes", place.placeLikes];
  cell.totalLabel.text = [NSString stringWithFormat:@"%@ people", place.placeCheckins];
  cell.countLabel.text = [NSString stringWithFormat:@"%@ friends", place.placeFriendCheckins];
}

+ (MoogleCellType)cellType {
  return MoogleCellTypePlain;
}

+ (CGFloat)rowHeight {
  CGFloat calculatedHeight = SPACING_Y; // top spacer
  
  // Name
  calculatedHeight += LABEL_HEIGHT + ICON_SPACING;
  
  // First row
  calculatedHeight += LABEL_HEIGHT + ICON_SPACING;
  
  // Second row
  calculatedHeight += LABEL_HEIGHT + ICON_SPACING;
  
  // Bottom spacer
  calculatedHeight += SPACING_Y;
  
  // If height is less than image, adjust
  if (calculatedHeight < IMAGE_HEIGHT_PLAIN + (SPACING_Y * 2)) {
    calculatedHeight = IMAGE_HEIGHT_PLAIN + (SPACING_Y * 2);
  }
  
  return calculatedHeight;
}

- (void)dealloc {
  RELEASE_SAFELY (_nameLabel);
  RELEASE_SAFELY (_distanceLabel);
  RELEASE_SAFELY (_countLabel);
  RELEASE_SAFELY(_likesLabel);
  RELEASE_SAFELY(_totalLabel)

  RELEASE_SAFELY(_likesIconView);
  RELEASE_SAFELY(_countIconView);
  RELEASE_SAFELY(_totalIconView);
  RELEASE_SAFELY(_distanceIconView);
  [super dealloc];
}

@end
