//
//  Place.h
//  Moogle
//
//  Created by Peter Shih on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoogleModel.h"

@interface Place : MoogleModel {
  NSString *_placeId;
  NSString *_placeName;
  NSString *_placePhone;
  NSString *_placeWebsite;
  NSString *_placePrice;
  NSString *_placeAttire;
  NSString *_placeStreet;
  NSString *_placeCity;
  NSString *_placeState;
  NSString *_placeZip;
  NSString *_placeCountry;
  NSString *_placeTerms;
  NSString *_placeCategories;
  NSString *_placeRating;
  NSString *_placePicture;
  
  NSNumber *_placeLat;
  NSNumber *_placeLng;
  NSNumber *_placeDistance;
  NSNumber *_placeCheckins;
  NSNumber *_placeFriendCheckins;
  NSNumber *_placeLikes;
  NSNumber *_placeReviews;
}

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy) NSString *placeId;
@property (nonatomic, copy) NSString *placeName;
@property (nonatomic, copy) NSString *placePhone;
@property (nonatomic, copy) NSString *placeWebsite;
@property (nonatomic, copy) NSString *placePrice;
@property (nonatomic, copy) NSString *placeAttire;
@property (nonatomic, copy) NSString *placeStreet;
@property (nonatomic, copy) NSString *placeCity;
@property (nonatomic, copy) NSString *placeState;
@property (nonatomic, copy) NSString *placeZip;
@property (nonatomic, copy) NSString *placeCountry;
@property (nonatomic, copy) NSString *placeTerms;
@property (nonatomic, copy) NSString *placeCategories;
@property (nonatomic, copy) NSString *placeRating;
@property (nonatomic, copy) NSString *placePicture;

@property (nonatomic, copy) NSNumber *placeLat;
@property (nonatomic, copy) NSNumber *placeLng;
@property (nonatomic, copy) NSNumber *placeDistance;
@property (nonatomic, copy) NSNumber *placeCheckins;
@property (nonatomic, copy) NSNumber *placeFriendCheckins;
@property (nonatomic, copy) NSNumber *placeLikes;
@property (nonatomic, copy) NSNumber *placeReviews;

@end
