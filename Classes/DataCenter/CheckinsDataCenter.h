//
//  CheckinsDataCenter.h
//  Moogle
//
//  Created by Peter Shih on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoogleDataCenter.h"

@interface CheckinsDataCenter : MoogleDataCenter {
  NSMutableArray *_checkinsArray;
}

@property (nonatomic, retain) NSMutableArray *checkinsArray;

@end
