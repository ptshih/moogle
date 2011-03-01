//
//  CheckinCell.h
//  Moogle
//
//  Created by Peter Shih on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoogleImageCell.h"

@interface CheckinCell : MoogleImageCell {
  UILabel *_nameLabel;
  UILabel *_placeNameLabel;
  UILabel *_timestampLabel;
  UILabel *_messageLabel;
  UILabel *_taggedLabel;
  
  UIImageView *_placeIconView;
  UIImageView *_messageIconView;
  UIImageView *_taggedIconView;
  
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *placeNameLabel;
@property (nonatomic, retain) UILabel *timestampLabel;
@property (nonatomic, retain) UILabel *messageLabel;
@property (nonatomic, retain) UILabel *taggedLabel;

+ (void)fillCell:(CheckinCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image;

@end