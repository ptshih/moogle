//
//  PlaceViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardViewController.h"
#import "MoogleDataCenterDelegate.h"

@class ASIHTTPRequest;
@class PlacesDataCenter;

@interface PlaceViewController : CardViewController <MoogleDataCenterDelegate> {
  // Params
  NSNumber *_placeId;
  NSString *_message;
  NSArray *_tagsArray; // Tagged friend IDs
  
  ASIHTTPRequest *_checkinHereRequest;
  ASIHTTPRequest *_placeRequest;
  PlacesDataCenter *_placesDataCenter;
}

@property (nonatomic, retain) NSNumber *placeId;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSArray *tagsArray;

@property (nonatomic, retain) ASIHTTPRequest *checkinHereRequest;
@property (nonatomic, retain) ASIHTTPRequest *placeRequest;
@property (nonatomic, retain) PlacesDataCenter *placesDataCenter;

- (void)checkinHere;

@end
