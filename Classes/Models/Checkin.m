//
//  Checkin.m
//  Moogle
//
//  Created by Peter Shih on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Checkin.h"

@implementation Checkin

@synthesize place = _place;

@synthesize checkinId = _checkinId;
@synthesize facebookId = _facebookId;
@synthesize facebookName = _facebookName;
@synthesize checkinMessage = _checkinMessage;
@synthesize checkinAppName = _checkinAppName;

@synthesize checkinTagsArray = _checkinTagsArray;
@synthesize checkinLikesArray = _checkinLikesArray;
@synthesize checkinCommentsArray = _checkinCommentsArray;

@synthesize checkinDate = _checkinDate;

- (id)initWithDictionary:(NSDictionary *)dictionary {
  self = [super initWithDictionary:dictionary];
  if (self) {
    // Place
    Place *checkinPlace = [[Place alloc] initWithDictionary:[dictionary objectForKey:@"place_data"]];
    self.place = checkinPlace;
    [checkinPlace release];
    
    // Strings
    self.checkinId = [dictionary valueForKey:@"checkin_id"];
    self.facebookId = [dictionary valueForKey:@"facebook_id"];
    self.facebookName = [dictionary valueForKey:@"name"];
    self.checkinMessage = [dictionary valueForKey:@"message"];
    
    // Arrays
    self.checkinTagsArray = [dictionary valueForKey:@"tagged_user_array"];
    self.checkinLikesArray = [dictionary valueForKey:@"likes_data"];
    self.checkinCommentsArray = [dictionary valueForKey:@"comments_data"];
    
    // Date
    self.checkinDate = [NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:@"checkin_timestamp"] integerValue]];
  }
  return self;
}

- (void)dealloc {
  RELEASE_SAFELY(_place);
  
  RELEASE_SAFELY(_checkinId);
  RELEASE_SAFELY(_facebookId);
  RELEASE_SAFELY(_facebookName);
  RELEASE_SAFELY(_checkinMessage);
  RELEASE_SAFELY(_checkinAppName);

  RELEASE_SAFELY(_checkinTagsArray);
  RELEASE_SAFELY(_checkinLikesArray);
  RELEASE_SAFELY(_checkinCommentsArray);
  
  RELEASE_SAFELY(_checkinDate);
  [super dealloc];
}

@end
