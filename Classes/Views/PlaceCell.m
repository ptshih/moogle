//
//  PlaceCell.m
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceCell.h"

@implementation PlaceCell

@synthesize placeImageView = _placeImageView;
@synthesize nameLabel = _nameLabel;
@synthesize distanceLabel = _distanceLabel;
@synthesize countLabel = _countLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _placeImageView = [[UIImageView alloc] init];
    _nameLabel = [[UILabel alloc] init];
    _distanceLabel = [[UILabel alloc] init];
    _countLabel = [[UILabel alloc] init];
    
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.distanceLabel.backgroundColor = [UIColor clearColor];
    self.countLabel.backgroundColor = [UIColor clearColor];
    
    self.nameLabel.textAlignment = UITextAlignmentLeft;
    self.distanceLabel.textAlignment = UITextAlignmentLeft;
    self.countLabel.textAlignment = UITextAlignmentRight;
    
    self.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.countLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
    self.nameLabel.numberOfLines = 1;
    
    [self.contentView addSubview:self.placeImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.distanceLabel];
    [self.contentView addSubview:self.countLabel];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.placeImageView.image = nil;
  self.nameLabel.text = nil;
  self.distanceLabel.text = nil;
  self.countLabel.text = nil;
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
  self.distanceLabel.top = 30.0;
  self.countLabel.top = 30.0;
  
  CGFloat textWidth = self.contentView.width - self.placeImageView.width - 3 * SPACING_X;
  CGSize textSize = CGSizeMake(textWidth, LABEL_HEIGHT);
  
  // Name
  CGSize nameSize = [self.nameLabel.text sizeWithFont:self.nameLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];
  self.nameLabel.width = nameSize.width;
  self.nameLabel.height = nameSize.height;
  self.nameLabel.left = left;
  
  // Distance
  CGSize distanceSize = [self.distanceLabel.text sizeWithFont:self.distanceLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
  self.distanceLabel.width = distanceSize.width;
  self.distanceLabel.height = distanceSize.height;
  self.distanceLabel.left =  self.contentView.bounds.size.width - self.distanceLabel.width - SPACING_X;
  
  // Timestamp
  CGSize countSize = [self.countLabel.text sizeWithFont:self.countLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
  self.countLabel.width = countSize.width;
  self.countLabel.height = countSize.height;
  self.countLabel.left = left;
}

+ (void)fillCell:(PlaceCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image {
  cell.placeImageView.image = image;
  
  // NOTE: make sure not <null>
  cell.nameLabel.text = [dictionary valueForKey:@"name"];
  cell.distanceLabel.text = [NSString stringWithFormat:@"%.2fmi", [[dictionary valueForKey:@"distance"] floatValue]];
  cell.countLabel.text = [NSString stringWithFormat:@"A: %@, F: %@, L: %@", [dictionary valueForKey:@"checkins_count"], [dictionary valueForKey:@"checkins_friend_count"], [dictionary valueForKey:@"like_count"]];
}

- (void)dealloc {
  RELEASE_SAFELY (_placeImageView);
  RELEASE_SAFELY (_nameLabel);
  RELEASE_SAFELY (_distanceLabel);
  RELEASE_SAFELY (_countLabel);
  [super dealloc];
}

@end
