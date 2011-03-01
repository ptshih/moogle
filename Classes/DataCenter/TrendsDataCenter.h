//
//  TrendsDataCenter.h
//  Moogle
//
//  Created by Peter Shih on 2/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoogleDataCenter.h"

@interface TrendsDataCenter : MoogleDataCenter {
  NSMutableArray *_responseArray;
}

@property (nonatomic, retain) NSMutableArray *responseArray;

@end
