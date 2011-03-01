//
//  TrendCell.h
//  Moogle
//
//  Created by Peter Shih on 2/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoogleImageCell.h"

@interface TrendCell : MoogleImageCell {
    
}

+ (void)fillCell:(TrendCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image;

@end
