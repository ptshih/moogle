//
//  WhoCell.h
//  Moogle
//
//  Created by Peter Shih on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoogleImageCell.h"

enum {
  WhoCellTypeFriend = 0,
  WhoCellTypeGroup = 1
};
typedef uint32_t WhoCellType;

@interface WhoCell : MoogleImageCell {  
  BOOL _isSelected;
}

@property (nonatomic, assign) BOOL isSelected;

+ (void)fillCell:(WhoCell *)cell withDictionary:(NSDictionary *)dictionary forType:(WhoCellType)type;

@end
