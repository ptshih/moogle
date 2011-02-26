//
//  PlaceCell.h
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoogleImageCell.h"

@interface PlaceCell : MoogleImageCell {
  UILabel *_nameLabel;
  UILabel *_distanceLabel;
  UILabel *_countLabel;
  UILabel *_statsLabel;
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *distanceLabel;
@property (nonatomic, retain) UILabel *countLabel;
@property (nonatomic, retain) UILabel *statsLabel;

+ (void)fillCell:(PlaceCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image;

@end
