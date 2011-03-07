//
//  CheckinsViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTableViewController.h"
#import "FriendPickerDelegate.h"
#import "MoogleDataCenterDelegate.h"

@class CheckinsDataCenter;
@class WhoViewController;

@interface CheckinsViewController : CardTableViewController <FriendPickerDelegate, MoogleDataCenterDelegate> {
  CheckinsDataCenter *_dataCenter;
  
  ASIHTTPRequest *_checkinsRequest;
  
  WhoViewController *_wvc;
  NSString *_who;
}

@property (nonatomic, retain) CheckinsDataCenter *dataCenter;
@property (nonatomic, retain) ASIHTTPRequest *checkinsRequest;

- (void)getCheckins;

@end
