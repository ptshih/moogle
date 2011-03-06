//
//  MoogleModel.h
//  Moogle
//
//  Created by Peter Shih on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface MoogleModel : NSObject <NSCopying> {
  NSDictionary *_dictionary;
}

@property (nonatomic, retain) NSDictionary *dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (id)copyWithZone:(NSZone *)zone;

@end
