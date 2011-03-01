//
//  PlaceReviewCell.h
//  Moogle
//
//  Created by Peter Shih on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoogleCell.h"

@interface PlaceReviewCell : MoogleCell {
  UILabel *_ratingLabel;
  UILabel *_reviewLabel;
}

@property (nonatomic, retain) UILabel *ratingLabel;
@property (nonatomic, retain) UILabel *reviewLabel;

+ (void)fillCell:(PlaceReviewCell *)cell withDictionary:(NSDictionary *)dictionary;

@end
