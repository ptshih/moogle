//
//  CheckinsViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTableViewController.h"
#import "WhoFilterDelegate.h"
#import "MoogleDataCenterDelegate.h"

@class FeedDataCenter;
@class WhoViewController;

@interface CheckinsViewController : CardTableViewController <WhoFilterDelegate, MoogleDataCenterDelegate> {
  FeedDataCenter *_dataCenter;
  
  ASIHTTPRequest *_checkinsRequest;
  
  WhoViewController *_wvc;
  NSString *_who;
}

@property (nonatomic, retain) FeedDataCenter *dataCenter;
@property (nonatomic, retain) ASIHTTPRequest *checkinsRequest;

- (void)getCheckins;

@end
