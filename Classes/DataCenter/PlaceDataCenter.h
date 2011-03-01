//
//  PlaceDataCenter.h
//  Moogle
//
//  Created by Peter Shih on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoogleDataCenter.h"

@interface PlaceDataCenter : MoogleDataCenter {
  ASIHTTPRequest *_checkinHereRequest;
  ASIHTTPRequest *_placeInfoRequest;
  ASIHTTPRequest *_placeActivityRequest;
  ASIHTTPRequest *_placeFeedRequest;
  ASIHTTPRequest *_placeReviewsRequest;
  
  NSMutableArray *_headersArray;
  NSMutableArray *_detailsArray;
  
  NSMutableArray *_activityArray;
  NSMutableArray *_feedArray;
  NSMutableArray *_reviewArray;
}

@property (nonatomic, assign) ASIHTTPRequest *checkinHereRequest;
@property (nonatomic, assign) ASIHTTPRequest *placeInfoRequest;
@property (nonatomic, assign) ASIHTTPRequest *placeActivityRequest;
@property (nonatomic, assign) ASIHTTPRequest *placeFeedRequest;
@property (nonatomic, assign) ASIHTTPRequest *placeReviewsRequest;

@property (nonatomic, retain) NSMutableArray *headersArray;
@property (nonatomic, retain) NSMutableArray *detailsArray;
@property (nonatomic, retain) NSMutableArray *activityArray;
@property (nonatomic, retain) NSMutableArray *feedArray;
@property (nonatomic, retain) NSMutableArray *reviewArray;

@end
