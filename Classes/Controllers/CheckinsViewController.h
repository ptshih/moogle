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

enum {
  CheckinsModeTimeline = 0,
  CheckinsModeTrending = 1
};
typedef uint32_t CheckinsMode;

@class CheckinsDataCenter;
@class TrendsDataCenter;
@class ASIHTTPRequest;
@class WhoViewController;

@interface CheckinsViewController : CardTableViewController <WhoFilterDelegate, MoogleDataCenterDelegate> {
  CheckinsDataCenter *_timelineDataCenter;
  TrendsDataCenter *_trendsDataCenter;
  
  ASIHTTPRequest *_checkinsRequest;
  ASIHTTPRequest *_trendsRequest;
  
  WhoViewController *_wvc;
  NSString *_who;
  
  CheckinsMode _mode;
}

@property (nonatomic, retain) CheckinsDataCenter *timelineDataCenter;
@property (nonatomic, retain) TrendsDataCenter *trendsDataCenter;
@property (nonatomic, retain) ASIHTTPRequest *checkinsRequest;
@property (nonatomic, retain) ASIHTTPRequest *trendsRequest;

- (void)getCheckins;

@end
