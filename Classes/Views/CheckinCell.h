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
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *placeNameLabel;
@property (nonatomic, retain) UILabel *timestampLabel;
@property (nonatomic, retain) UILabel *countLabel;

+ (void)fillCell:(CheckinCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image;

@end