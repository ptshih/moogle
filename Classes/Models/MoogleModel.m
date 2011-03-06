//
//  MoogleModel.m
//  Moogle
//
//  Created by Peter Shih on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MoogleModel.h"

@implementation MoogleModel

@synthesize dictionary = _dictionary;

- (id)copyWithZone:(NSZone *)zone {
  id copy = [[[self class] allocWithZone:zone] initWithDictionary:self.dictionary];
  
  return copy;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
  self = [super init];
  if (self) {
    self.dictionary = dictionary;
  }
  return self;
}

- (void)dealloc {
  RELEASE_SAFELY(_dictionary);
  [super dealloc];
}
@end
