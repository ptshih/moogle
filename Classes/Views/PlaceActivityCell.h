//
//  PlaceActivityCell.h
//  Moogle
//
//  Created by Peter Shih on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoogleImageCell.h"

@interface PlaceActivityCell : MoogleImageCell {
  UILabel *_nameLabel;
  UILabel *_timestampLabel;
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *timestampLabel;

+ (void)fillCell:(PlaceActivityCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image;

@end
