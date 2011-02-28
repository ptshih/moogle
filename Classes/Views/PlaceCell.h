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
  UILabel *_countLabel; // friends checkins count
  UILabel *_totalLabel; // total checkins count
  UILabel *_likesLabel;
  
  UIImageView *_likesIconView;
  UIImageView *_countIconView;
  UIImageView *_totalIconView;
  UIImageView *_distanceIconView;
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *distanceLabel;
@property (nonatomic, retain) UILabel *countLabel;
@property (nonatomic, retain) UILabel *totalLabel;
@property (nonatomic, retain) UILabel *likesLabel;

+ (void)fillCell:(PlaceCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image;

@end
