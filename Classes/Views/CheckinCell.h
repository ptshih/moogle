//
//  CheckinCell.h
//  Moogle
//
//  Created by Peter Shih on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoogleImageCell.h"

@class Checkin;

@interface CheckinCell : MoogleImageCell {
  UILabel *_nameLabel;
  UILabel *_placeNameLabel;
  UILabel *_timestampLabel;
  UILabel *_taggedLabel;
  UILabel *_messageLabel;
  UILabel *_likesCommentsLabel;
  
  UIImageView *_placeIconView;
  UIImageView *_taggedIconView;
  UIImageView *_likeIconView;
  
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *placeNameLabel;
@property (nonatomic, retain) UILabel *timestampLabel;
@property (nonatomic, retain) UILabel *taggedLabel;
@property (nonatomic, retain) UILabel *messageLabel;
@property (nonatomic, retain) UILabel *likesCommentsLabel;

+ (void)fillCell:(CheckinCell *)cell withCheckin:(Checkin *)checkin withImage:(UIImage *)image;
+ (CGFloat)variableRowHeightWithCheckin:(Checkin *)checkin;

@end