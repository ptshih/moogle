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
#import "NearbyPickerDelegate.h"
#import "FriendPickerDelegate.h"

@class ASIHTTPRequest;
@class MoogleDataCenter;
@class Place;

@interface CheckinHereViewController : CardViewController <MoogleDataCenterDelegate, NearbyPickerDelegate, UITextViewDelegate, FriendPickerDelegate> {
  MoogleDataCenter *_dataCenter;
  ASIHTTPRequest *_checkinHereRequest;
  
  NSString *_message;
  NSString *_taggedFriends; // Tagged friend IDs
  
  Place *_place;
  UILabel *_placeAddressLabel;
  UILabel *_placeNameLabel;
  UILabel *_taggedLabel;
  UITextView *_checkinMessage;
}

@property (nonatomic, retain) IBOutlet UILabel *placeAddressLabel;
@property (nonatomic, retain) IBOutlet UILabel *placeNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *taggedLabel;
@property (nonatomic, retain) IBOutlet UITextView *checkinMessage;

@property (nonatomic, retain) MoogleDataCenter *dataCenter;
@property (nonatomic, retain) ASIHTTPRequest *checkinHereRequest;

@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *taggedFriends;

@property (nonatomic, assign) Place *place;

- (IBAction)checkinHere;
- (IBAction)cancel;
- (IBAction)tagFriends;
- (IBAction)checkinHere;
- (IBAction)choosePlace;

@end
