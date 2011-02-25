//
//  PlaceCell.h
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoogleCell.h"

@interface PlaceCell : MoogleCell {
  UIImageView *_placeImageView;
  UILabel *_nameLabel;
  UILabel *_distanceLabel;
  UILabel *_countLabel;
}

@property (nonatomic, retain) UIImageView *placeImageView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *distanceLabel;
@property (nonatomic, retain) UILabel *countLabel;

+ (void)fillCell:(PlaceCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image;

@end
