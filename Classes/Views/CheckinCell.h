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
  UILabel *_countLabel;
  UILabel *_taggedLabel;
  
  UIImageView *_placeIconView;
  UIImageView *_countIconView;
  UIImageView *_taggedIconView;
  
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *placeNameLabel;
@property (nonatomic, retain) UILabel *timestampLabel;
@property (nonatomic, retain) UILabel *countLabel;
@property (nonatomic, retain) UILabel *taggedLabel;

+ (void)fillCell:(CheckinCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image;

@end