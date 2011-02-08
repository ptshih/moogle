//
//  PlaceViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASIHTTPRequest;

@interface PlaceViewController : UIViewController {
  IBOutlet UIButton *_checkinButton;
  
  // Params
  NSNumber *_placeId;
  NSString *_message;
  NSArray *_tagsArray; // Tagged friend IDs
  
  ASIHTTPRequest *_checkinHereRequest;
}

@property (nonatomic, retain) UIButton *checkinButton;

@property (nonatomic, retain) NSNumber *placeId;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSArray *tagsArray;

@property (nonatomic, retain) ASIHTTPRequest *checkinHereRequest;

- (IBAction)checkinHere;

@end
