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

@class CheckinsDataCenter;
@class ASIHTTPRequest;
@class WhoViewController;

@interface CheckinsViewController : CardTableViewController <WhoFilterDelegate, MoogleDataCenterDelegate> {
  CheckinsDataCenter *_dataCenter;
  ASIHTTPRequest *_checkinsRequest;
  UIBarButtonItem *_filterButton;
  UIView *_filterView;
  BOOL _isFiltering;
  
  WhoViewController *_wvc;
  NSString *_who;
}

@property (nonatomic, retain) CheckinsDataCenter *dataCenter;
@property (nonatomic, retain) ASIHTTPRequest *checkinsRequest;
@property (nonatomic, retain) UIView *filterView;

- (void)getCheckins;

@end
