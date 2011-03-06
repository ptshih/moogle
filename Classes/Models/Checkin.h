//
//  Checkin.h
//  Moogle
//
//  Created by Peter Shih on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoogleModel.h"
#import "Place.h"

@interface Checkin : MoogleModel {
  Place *_place;
  NSString *_checkinId;
  NSString *_facebookId;
  NSString *_facebookName;
  NSString *_checkinMessage;
  NSString *_checkinAppName;
  
  NSNumber *_checkinAppId;
  NSNumber *_checkinLikesCount;
  NSNumber *_checkinCommentsCount;
  NSNumber *_checkinTagsCount;
  
  NSArray *_checkinTagsArray;
  NSArray *_checkinLikesArray;
  NSArray *_checkinCommentsArray;
  
  NSDate *_checkinDate;
}

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy) Place *place;

@property (nonatomic, copy) NSString *checkinId;
@property (nonatomic, copy) NSString *facebookId;
@property (nonatomic, copy) NSString *facebookName;
@property (nonatomic, copy) NSString *checkinMessage;
@property (nonatomic, copy) NSString *checkinAppName;

@property (nonatomic, copy) NSDate *checkinDate;

@end
