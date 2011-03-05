//
//  CheckinHereViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardModalViewController.h"
#import "MoogleDataCenterDelegate.h"

@class ASIHTTPRequest;
@class MoogleDataCenter;

@interface CheckinHereViewController : CardModalViewController <MoogleDataCenterDelegate> {
  MoogleDataCenter *_dataCenter;
  ASIHTTPRequest *_checkinHereRequest;
  
  NSString *_message;
  NSArray *_tagsArray; // Tagged friend IDs
  
  NSString *_placeId;
  NSString *_placeName;
}

@property (nonatomic, retain) MoogleDataCenter *dataCenter;
@property (nonatomic, retain) ASIHTTPRequest *checkinHereRequest;

@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSArray *tagsArray;

@property (nonatomic, retain) NSString *placeId;
@property (nonatomic, retain) NSString *placeName;

- (IBAction)checkinHere;
- (IBAction)cancel;

@end
