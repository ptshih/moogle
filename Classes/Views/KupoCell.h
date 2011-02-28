//
//  KupoCell.h
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoogleImageCell.h"

@interface KupoCell : MoogleImageCell {
  UILabel *_nameLabel;
  UILabel *_placeNameLabel;
  UILabel *_timestampLabel;
  UILabel *_referLabel;
  
  UIImageView *_placeIconView;
  UIImageView *_referIconView;
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *placeNameLabel;
@property (nonatomic, retain) UILabel *timestampLabel;
@property (nonatomic, retain) UILabel *referLabel;

+ (void)fillCell:(KupoCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image;

@end
