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
  UILabel *_kupoLabel;
}

@property (nonatomic, retain) UILabel *kupoLabel;

+ (void)fillCell:(KupoCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image;

@end
