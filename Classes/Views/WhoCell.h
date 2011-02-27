//
//  WhoCell.h
//  Moogle
//
//  Created by Peter Shih on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoogleImageCell.h"

@interface WhoCell : MoogleImageCell {
  UILabel *_nameLabel;
}

@property (nonatomic, retain) UILabel *nameLabel;

+ (void)fillCell:(WhoCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image;

@end
