//
//  PlaceHeaderCell.m
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceHeaderCell.h"
#import "Constants.h"

@implementation PlaceHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _totalLabel = [[UILabel alloc] init];
    _friendsLabel = [[UILabel alloc] init];
    _likesLabel = [[UILabel alloc] init];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
}

- (void)layoutSubviews {
  [super layoutSubviews];

}

+ (void)fillCell:(PlaceHeaderCell *)cell withDictionary:(NSDictionary *)dictionary {
  
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

//
//
//- (void)setupHeaderView {
//  _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
//  UIImageView *placeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(210, 0, 100, 100)];
//  _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 27)];
//  _friendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 27, 200, 27)];
//  _likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 54, 200, 27)];
//  
//  _headerView.backgroundColor = FB_COLOR_VERY_LIGHT_BLUE;
//  placeImageView.backgroundColor = [UIColor clearColor];
//  _totalLabel.backgroundColor = [UIColor clearColor];
//  _friendsLabel.backgroundColor = [UIColor clearColor];
//  _likesLabel.backgroundColor = [UIColor clearColor];
//  
//  placeImageView.contentMode = UIViewContentModeScaleAspectFit;
//  placeImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", self.placeId]]]];
//  
//  _totalLabel.text = @"Total: Loading...";
//  _friendsLabel.text = @"Friends: Loading...";
//  _likesLabel.text = @"Likes: Loading...";
//  
//  [placeImageView release];
//}
//
//- (void)updateHeaderView {
//  //  {"name":"LinkedIn HQ","street":null,"city":null,"state":null,"country":null,"zip":null,"phone":null,"checkins_count":null,"distance":0.03135450056826266,"checkins_friend_count":0,"like_count":null,"attire":null,"website":null,"price":null}
//  _totalLabel.text = [NSString stringWithFormat:@"Total: %@", [self.dataCenter.parsedResponse objectForKey:@"checkins_count"]];
//  _friendsLabel.text = [NSString stringWithFormat:@"Friends: %@", [self.dataCenter.parsedResponse objectForKey:@"checkins_friend_count"]];
//  _likesLabel.text = [NSString stringWithFormat:@"Likes: %@", [self.dataCenter.parsedResponse objectForKey:@"like_count"]];
//}

@end
