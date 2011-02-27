//
//  PlacesDataCenter.h
//  Moogle
//
//  Created by Peter Shih on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoogleDataCenter.h"

@interface PlacesDataCenter : MoogleDataCenter {
  ASIHTTPRequest *_checkinHereRequest;
  ASIHTTPRequest *_placeInfoRequest;
  ASIHTTPRequest *_placeActivityRequest;
  ASIHTTPRequest *_placeFeedRequest;
  
  NSMutableArray *_headersArray;
  NSMutableArray *_detailsArray;
  
  NSMutableArray *_activityArray;
  NSMutableArray *_feedArray;
}

@property (nonatomic, assign) ASIHTTPRequest *checkinHereRequest;
@property (nonatomic, assign) ASIHTTPRequest *placeInfoRequest;
@property (nonatomic, assign) ASIHTTPRequest *placeActivityRequest;
@property (nonatomic, assign) ASIHTTPRequest *placeFeedRequest;

@property (nonatomic, retain) NSMutableArray *headersArray;
@property (nonatomic, retain) NSMutableArray *detailsArray;
@property (nonatomic, retain) NSMutableArray *activityArray;
@property (nonatomic, retain) NSMutableArray *feedArray;

@end
