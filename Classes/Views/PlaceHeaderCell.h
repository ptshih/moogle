//
//  PlaceHeaderCell.h
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoogleCell.h"

@interface PlaceHeaderCell : MoogleCell {
  UIImageView *_placeImageView;
  UILabel *_totalLabel;
  UILabel *_friendsLabel;
  UILabel *_likesLabel;    
}

+ (void)fillCell:(PlaceHeaderCell *)cell withDictionary:(NSDictionary *)dictionary;

@property (nonatomic, retain) UIImageView *placeImageView;
@property (nonatomic, retain) UILabel *totalLabel;
@property (nonatomic, retain) UILabel *friendsLabel;
@property (nonatomic, retain) UILabel *likesLabel;

@end
