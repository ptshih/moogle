//
//  WhoFilterDelegate.h
//  Moogle
//
//  Created by Peter Shih on 2/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WhoFilterDelegate <NSObject>
@optional
- (void)whoPickedWithString:(NSString *)whoString;

@end