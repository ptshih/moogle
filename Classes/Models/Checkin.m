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

@synthesize checkinDate = _checkinDate;

- (id)initWithDictionary:(NSDictionary *)dictionary {
  self = [super initWithDictionary:dictionary];
  if (self) {
    // Place
    Place *checkinPlace = [[Place alloc] initWithDictionary:[dictionary objectForKey:@"place"]];
    self.place = checkinPlace;
    [checkinPlace release];
    
    // Strings
    self.checkinId = [dictionary objectForKey:@"checkin_id"];
    self.facebookId = [dictionary objectForKey:@"facebook_id"];
    self.facebookName = [dictionary objectForKey:@"name"];
    self.checkinMessage = [dictionary objectForKey:@"message"];
    
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
  
  RELEASE_SAFELY(_checkinDate);
  [super dealloc];
}

@end
