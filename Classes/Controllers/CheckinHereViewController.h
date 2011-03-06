//
//  CheckinHereViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardViewController.h"
#import "MoogleDataCenterDelegate.h"

@class ASIHTTPRequest;
@class MoogleDataCenter;
@class Place;

@interface CheckinHereViewController : CardViewController <MoogleDataCenterDelegate, UITextFieldDelegate> {
  MoogleDataCenter *_dataCenter;
  ASIHTTPRequest *_checkinHereRequest;
  
  NSString *_message;
  NSArray *_tagsArray; // Tagged friend IDs
  
  Place *_place;
  UITextField *_checkinMessage;
  UILabel *_placeAddressLabel;
  UILabel *_placeNameLabel;
}
@property (nonatomic, retain) IBOutlet UITextField *checkinMessage;
@property (nonatomic, retain) IBOutlet UILabel *placeAddressLabel;
@property (nonatomic, retain) IBOutlet UILabel *placeNameLabel;

@property (nonatomic, retain) MoogleDataCenter *dataCenter;
@property (nonatomic, retain) ASIHTTPRequest *checkinHereRequest;

@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSArray *tagsArray;

@property (nonatomic, assign) Place *place;

- (IBAction)checkinHere;
- (IBAction)cancel;
- (IBAction)tagFriends;
- (IBAction)checkinHere;

@end
