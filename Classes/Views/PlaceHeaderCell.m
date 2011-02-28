//
//  PlaceHeaderCell.m
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceHeaderCell.h"
#import "Constants.h"

#define SPACING_X 10.0
#define SPACING_Y 8.0
#define LABEL_HEIGHT 24.0
#define IMG_WIDTH 72.0
#define IMG_HEIGHT 72.0

@implementation PlaceHeaderCell

@synthesize totalLabel = _totalLabel;
@synthesize friendsLabel = _friendsLabel;
@synthesize likesLabel = _likesLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _totalLabel = [[UILabel alloc] init];
    _friendsLabel = [[UILabel alloc] init];
    _likesLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview:self.totalLabel];
    [self.contentView addSubview:self.friendsLabel];
    [self.contentView addSubview:self.likesLabel];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.imageView.image = nil;
  self.totalLabel.text = nil;
  self.friendsLabel.text = nil;
  self.likesLabel.text = nil;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat left = SPACING_X;
  CGFloat textWidth = self.contentView.width;
  CGSize textSize = CGSizeMake(textWidth, 24.0);
  CGSize labelSize = CGSizeZero;
  
  // Image View
  self.imageView.left = self.contentView.width - SPACING_X - IMG_WIDTH;
  self.imageView.top = SPACING_Y;
  self.imageView.width = IMG_WIDTH;
  self.imageView.height = IMG_HEIGHT;
  
  // Vertical
  self.totalLabel.top = SPACING_Y;
  self.friendsLabel.top = SPACING_Y + LABEL_HEIGHT * 1;
  self.likesLabel.top = SPACING_Y + LABEL_HEIGHT * 2;
  
  // Total
  labelSize = [self.totalLabel.text sizeWithFont:self.totalLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];  
  self.totalLabel.width = labelSize.width;
  self.totalLabel.height = labelSize.height;
  self.totalLabel.left = left;
  
  // Friends
  labelSize = [self.friendsLabel.text sizeWithFont:self.friendsLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];  
  self.friendsLabel.width = labelSize.width;
  self.friendsLabel.height = labelSize.height;
  self.friendsLabel.left = left;
  
  // Likes
  labelSize = [self.likesLabel.text sizeWithFont:self.likesLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeTailTruncation];  
  self.likesLabel.width = labelSize.width;
  self.likesLabel.height = labelSize.height;
  self.likesLabel.left = left;
}

+ (void)fillCell:(PlaceHeaderCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image {
  cell.imageView.image = image;
  cell.totalLabel.text = [NSString stringWithFormat:@"Total: %@", [dictionary objectForKey:@"checkins_count"]];
  cell.friendsLabel.text = [NSString stringWithFormat:@"Friends: %@", [dictionary objectForKey:@"checkins_friend_count"]];
  cell.likesLabel.text = [NSString stringWithFormat:@"Likes: %@", [dictionary objectForKey:@"like_count"]];
}

+ (CGFloat)rowHeight {
  // Subclasses should override
  return 88.0;
}

- (void)dealloc {
  RELEASE_SAFELY (_totalLabel);
  RELEASE_SAFELY (_friendsLabel);
  RELEASE_SAFELY (_likesLabel);
  [super dealloc];
} 


@end
