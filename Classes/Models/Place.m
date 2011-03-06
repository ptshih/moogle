//
//  Place.m
//  Moogle
//
//  Created by Peter Shih on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Place.h"

@implementation Place

@synthesize placeId = _placeId;
@synthesize placeName = _placeName;
@synthesize placePhone = _placePhone;
@synthesize placeWebsite = _placeWebsite;
@synthesize placePrice = _placePrice;
@synthesize placeAttire = _placeAttire;
@synthesize placeStreet = _placeStreet;
@synthesize placeCity = _placeCity;
@synthesize placeState = _placeState;
@synthesize placeZip = _placeZip;
@synthesize placeCountry = _placeCountry;
@synthesize placeTerms = _placeTerms;
@synthesize placeCategories = _placeCategories;

@synthesize placeLat = _placeLat;
@synthesize placeLng = _placeLng;
@synthesize placeDistance = _placeDistance;
@synthesize placeCheckins = _placeCheckins;
@synthesize placeFriendCheckins = _placeFriendCheckins;
@synthesize placeLikes = _placeLikes;
@synthesize placeReviews = _placeReviews;
@synthesize placeRating = _placeRating;

- (id)initWithDictionary:(NSDictionary *)dictionary {
  self = [super initWithDictionary:dictionary];
  if (self) {
    // Strings
    self.placeId = [dictionary valueForKey:@"place_id"];
    self.placeName = [dictionary valueForKey:@"place_name"];
    self.placePhone = [dictionary valueForKey:@"place_phone"];
    self.placeWebsite = [dictionary valueForKey:@"place_website"];
    self.placePrice = [dictionary valueForKey:@"place_price"];
    self.placeAttire = [dictionary valueForKey:@"place_attire"];
    self.placeStreet = [dictionary valueForKey:@"place_street"];
    self.placeCity = [dictionary valueForKey:@"place_city"];
    self.placeState = [dictionary valueForKey:@"place_state"];
    self.placeZip = [dictionary valueForKey:@"place_zip"];
    self.placeCountry = [dictionary valueForKey:@"place_country"];
    self.placeTerms = [dictionary valueForKey:@"place_terms"];
    self.placeCategories = [dictionary valueForKey:@"place_categories"];
    self.placeRating = ([[dictionary valueForKey:@"place_rating"] notNil]) ? [[[dictionary valueForKey:@"place_rating"] componentsSeparatedByString:@" "] objectAtIndex:0] : nil;
    
    // Numbers
    self.placeLat = [dictionary valueForKey:@"place_lat"];
    self.placeLng = [dictionary valueForKey:@"place_lng"];
    self.placeDistance = [dictionary valueForKey:@"place_distance"];
    self.placeCheckins = [dictionary valueForKey:@"place_checkins"];
    self.placeFriendCheckins = [dictionary valueForKey:@"place_friend_checkins"];
    self.placeLikes = [dictionary valueForKey:@"place_likes"];
    self.placeReviews = [dictionary valueForKey:@"place_reviews"];
  }
  return self;
}

- (void)dealloc {
  RELEASE_SAFELY(_placeId);
  RELEASE_SAFELY(_placeName);
  RELEASE_SAFELY(_placePhone);
  RELEASE_SAFELY(_placeWebsite);
  RELEASE_SAFELY(_placePrice);
  RELEASE_SAFELY(_placeAttire);
  RELEASE_SAFELY(_placeStreet);
  RELEASE_SAFELY(_placeCity);
  RELEASE_SAFELY(_placeState);
  RELEASE_SAFELY(_placeZip);
  RELEASE_SAFELY(_placeCountry);
  RELEASE_SAFELY(_placeTerms);
  RELEASE_SAFELY(_placeCategories);
  
  RELEASE_SAFELY(_placeLat);
  RELEASE_SAFELY(_placeLng);
  RELEASE_SAFELY(_placeDistance);
  RELEASE_SAFELY(_placeCheckins);
  RELEASE_SAFELY(_placeFriendCheckins);
  RELEASE_SAFELY(_placeLikes);
  RELEASE_SAFELY(_placeReviews);
  RELEASE_SAFELY(_placeRating);
  [super dealloc];
}

@end