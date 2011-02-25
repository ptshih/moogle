//
//  CheckinCell.m
//  Moogle
//
//  Created by Peter Shih on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CheckinCell.h"
#import "Constants.h"
#import "NSDate+HumanInterval.h"

#define SPACING_X 7.0

@implementation CheckinCell

@synthesize placeImageView = _placeImageView;
@synthesize nameLabel = _nameLabel;
@synthesize placeNameLabel = _placeNameLabel;
@synthesize timestampLabel = _timestampLabel;
@synthesize countLabel = _countLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _placeImageView = [[UIImageView alloc] init];
    _nameLabel = [[UILabel alloc] init];
    _placeNameLabel = [[UILabel alloc] init];
    _timestampLabel = [[UILabel alloc] init];
    _countLabel = [[UILabel alloc] init];
    
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.placeNameLabel.backgroundColor = [UIColor clearColor];
    self.countLabel.backgroundColor = [UIColor clearColor];
    self.timestampLabel.backgroundColor = [UIColor clearColor];
    
    self.nameLabel.textAlignment = UITextAlignmentLeft;
    self.placeNameLabel.textAlignment = UITextAlignmentLeft;
    self.countLabel.textAlignment = UITextAlignmentRight;
    self.timestampLabel.textAlignment = UITextAlignmentRight;
    
    self.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.placeNameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
    [self.contentView addSubview:self.placeImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.placeNameLabel];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.timestampLabel];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.placeImageView.image = nil;
  self.nameLabel.text = nil;
  self.placeNameLabel.text = nil;
  self.countLabel.text = nil;
  self.timestampLabel.text = nil;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat left = SPACING_X;
  
  self.placeImageView.left = left;
  self.placeImageView.top = 5.0;
  self.placeImageView.width = 50.0;
  self.placeImageView.height = 50.0;
  
  left = self.placeImageView.right + SPACING_X;
  
  self.nameLabel.top = 8.0;
  self.placeNameLabel.top = 30.0;
  self.countLabel.top = 8.0;
  self.timestampLabel.top = 30.0;
  
  CGFloat textWidth = self.contentView.width - self.placeImageView.width - 3 * SPACING_X;
  CGSize textSize = CGSizeMake(textWidth, INT_MAX);
  
  // Name
  CGSize nameSize = [self.nameLabel.text sizeWithFont:self.nameLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
  self.nameLabel.width = nameSize.width;
  self.nameLabel.height = nameSize.height;
  self.nameLabel.left = left;
  
  // Place Name
  CGSize placeNameSize = [self.placeNameLabel.text sizeWithFont:self.placeNameLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
  self.placeNameLabel.width = placeNameSize.width;
  self.placeNameLabel.height = placeNameSize.height;
  self.placeNameLabel.left = left;
  
  // Checkin Count
  CGSize countSize = [self.countLabel.text sizeWithFont:self.countLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
  self.countLabel.width = countSize.width;
  self.countLabel.height = countSize.height;
  self.countLabel.left =  self.contentView.bounds.size.width - self.countLabel.width - SPACING_X;
  
  // Timestamp
  CGSize timestampSize = [self.timestampLabel.text sizeWithFont:self.timestampLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
  self.timestampLabel.width = timestampSize.width;
  self.timestampLabel.height = timestampSize.height;
  self.timestampLabel.left = self.contentView.bounds.size.width - self.timestampLabel.width - SPACING_X;
}

+ (void)fillCell:(CheckinCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image {
  cell.placeImageView.image = image;
  
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:@"checkin_timestamp"] integerValue]];
  
  
  cell.nameLabel.text = [dictionary objectForKey:@"name"];
  cell.placeNameLabel.text = [dictionary objectForKey:@"place_name"];
  cell.countLabel.text = @"1";
  cell.timestampLabel.text = [date humanIntervalSinceNow];

}

                              
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  // Configure the view for the selected state.
}

- (void)dealloc {
  RELEASE_SAFELY (_placeImageView);
  RELEASE_SAFELY (_nameLabel);
  RELEASE_SAFELY (_placeNameLabel);
  RELEASE_SAFELY (_timestampLabel);
  RELEASE_SAFELY (_countLabel);
  [super dealloc];
}

@end