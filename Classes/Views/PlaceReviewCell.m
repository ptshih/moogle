//
//  PlaceReviewCell.m
//  Moogle
//
//  Created by Peter Shih on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceReviewCell.h"

#define CELL_FONT_SIZE 14.0
#define SPACING_X 5.0
#define SPACING_Y 5.0
#define LABEL_HEIGHT 20.0

@implementation PlaceReviewCell

@synthesize ratingLabel = _ratingLabel;
@synthesize reviewLabel = _reviewLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _ratingLabel = [[UILabel alloc] init];
    _reviewLabel = [[UILabel alloc] init];
    
    self.ratingLabel.backgroundColor = [UIColor clearColor];
    self.reviewLabel.backgroundColor = [UIColor clearColor];
    
    self.ratingLabel.font = [UIFont boldSystemFontOfSize:CELL_FONT_SIZE];
    self.reviewLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
    
    self.ratingLabel.textAlignment = UITextAlignmentLeft;
    self.reviewLabel.textAlignment = UITextAlignmentLeft;
    
    self.reviewLabel.numberOfLines = 500;
    
    self.ratingLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.reviewLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
    [self.contentView addSubview:self.ratingLabel];
    [self.contentView addSubview:self.reviewLabel];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.ratingLabel.text = nil;
  self.reviewLabel.text = nil;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat left = SPACING_X;
  CGFloat textWidth = 0.0;
  CGSize textSize = CGSizeZero;
  CGSize labelSize = CGSizeZero;
  
  // Initial Y Positions
  self.ratingLabel.top = SPACING_Y;
  self.reviewLabel.top = SPACING_Y + LABEL_HEIGHT;
  
  // Rating
  textWidth = self.contentView.width - left - SPACING_X;
  textSize = CGSizeMake(textWidth, LABEL_HEIGHT);
  
  labelSize = [self.ratingLabel.text sizeWithFont:self.ratingLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.ratingLabel.width = labelSize.width;
  self.ratingLabel.height = labelSize.height;
  self.ratingLabel.left = left;
  
  // Review
  textWidth = self.contentView.width - left - SPACING_X;
  textSize = CGSizeMake(textWidth, INT_MAX);
  
  labelSize = [self.reviewLabel.text sizeWithFont:self.reviewLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
  self.reviewLabel.width = labelSize.width;
  self.reviewLabel.height = labelSize.height;
  self.reviewLabel.left = left;
}

+ (void)fillCell:(PlaceReviewCell *)cell withDictionary:(NSDictionary *)dictionary {
  cell.ratingLabel.text = [dictionary valueForKey:@"rating"];
  cell.reviewLabel.text = [dictionary valueForKey:@"text"];
}

+ (MoogleCellType)cellType {
  return MoogleCellTypeGrouped;
}

+ (CGFloat)variableRowHeightWithDictionary:(NSDictionary *)dictionary {
  CGFloat calculatedHeight = 0.0;
  
  CGFloat left = SPACING_X;
  CGFloat textWidth = 300;
  CGSize textSize = CGSizeZero;
  CGSize labelSize = CGSizeZero;
  
  // Name
  calculatedHeight = calculatedHeight + LABEL_HEIGHT;
  
  // Message
  textWidth = 300 - left - SPACING_X;
  textSize = CGSizeMake(textWidth, INT_MAX);
  
  labelSize = [[dictionary objectForKey:@"text"] sizeWithFont:[UIFont systemFontOfSize:CELL_FONT_SIZE] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
  
  calculatedHeight = calculatedHeight + labelSize.height;
  
  calculatedHeight = calculatedHeight + SPACING_Y * 2; // This is spacing*2 because its for top AND bottom
  
  return calculatedHeight;
}

- (void)dealloc {
  RELEASE_SAFELY(_ratingLabel);
  RELEASE_SAFELY(_reviewLabel);
  [super dealloc];
}

@end
