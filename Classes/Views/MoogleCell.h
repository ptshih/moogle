//
//  MoogleCell.h
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface MoogleCell : UITableViewCell {
  CGFloat _desiredHeight;
}

@property (nonatomic, assign) CGFloat desiredHeight;

+ (CGFloat)rowHeight;
+ (CGFloat)variableRowHeightForCell:(id)cell;

@end
