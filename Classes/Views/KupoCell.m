//
//  KupoCell.m
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KupoCell.h"

#define CELL_FONT_SIZE 14.0
#define SPACING_X 4.0
#define SPACING_Y 4.0
#define LABEL_HEIGHT 17.0

@implementation KupoCell

@synthesize kupoLabel = _kupoLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
  // Initialization code
    _kupoLabel = [[UILabel alloc] init];
    
    self.kupoLabel.backgroundColor = [UIColor clearColor];
    
    self.kupoLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
    
    self.kupoLabel.textAlignment = UITextAlignmentLeft;
    
    self.kupoLabel.numberOfLines = 100;
    
    self.kupoLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
    [self.contentView addSubview:self.kupoLabel];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.kupoLabel.text = nil;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  // Image
  self.imageView.left = SPACING_X;
  self.imageView.top = SPACING_Y;
  self.imageView.width = 50.0;
  self.imageView.height = 50.0;
  
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
  
  self.kupoLabel.top = SPACING_Y;

  textWidth = self.contentView.width - left - SPACING_X;
  textSize = CGSizeMake(textWidth, INT_MAX);
  
  labelSize = [self.kupoLabel.text sizeWithFont:self.kupoLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
  self.kupoLabel.width = labelSize.width;
  self.kupoLabel.height = labelSize.height;
  self.kupoLabel.left = left;
  
}

+ (void)fillCell:(KupoCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image {
  cell.imageView.image = image;
  
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:@"created_time"] integerValue]];
  
  NSString *kupo = [NSString stringWithFormat:@"%@ referred %@ to %@ %@", [dictionary objectForKey:@"refer_name"], [dictionary objectForKey:@"name"], [dictionary objectForKey:@"place_name"], [date humanIntervalSinceNow]];
  
  cell.kupoLabel.text = kupo;
}

+ (CGFloat)variableRowHeightWithDictionary:(NSDictionary *)dictionary {
  CGFloat calculatedHeight = 0.0;
  
  CGFloat left = SPACING_X;
  CGFloat textWidth = 320;
  CGSize textSize = CGSizeZero;
  CGSize labelSize = CGSizeZero;
  
  // Dynamically Space for Image
  //  if (self.imageView.image) {
  //    left = self.imageView.right + SPACING_X;
  //  }
  
  // Always leave space for image
  left = left + IMAGE_WIDTH + SPACING_X * 2;
  
  textWidth = 320 - left - SPACING_X;
  textSize = CGSizeMake(textWidth, INT_MAX);
  
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:@"created_time"] integerValue]];
  
  NSString *kupo = [NSString stringWithFormat:@"%@ referred %@ to %@ %@", [dictionary objectForKey:@"refer_name"], [dictionary objectForKey:@"name"], [dictionary objectForKey:@"place_name"], [date humanIntervalSinceNow]];
  
  labelSize = [kupo sizeWithFont:[UIFont systemFontOfSize:CELL_FONT_SIZE] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
  
  calculatedHeight = calculatedHeight + labelSize.height;
  
  calculatedHeight = calculatedHeight + SPACING_Y * 2; // This is spacing*2 because its for top AND bottom
  
  if (calculatedHeight < 60) calculatedHeight = 60;
  
  return calculatedHeight;
}

- (void)dealloc {
  RELEASE_SAFELY(_kupoLabel);
  [super dealloc];
}

@end
