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
  ASIHTTPRequest *_placeRequest;
  
  NSMutableArray *_headersArray;
  NSMutableArray *_detailsArray;
}

@property (nonatomic, assign) ASIHTTPRequest *checkinHereRequest;
@property (nonatomic, assign) ASIHTTPRequest *placeRequest;

@property (nonatomic, retain) NSMutableArray *headersArray;
@property (nonatomic, retain) NSMutableArray *detailsArray;

@end
