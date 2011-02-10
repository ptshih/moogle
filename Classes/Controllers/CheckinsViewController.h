//
//  CheckinsViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardViewController.h"

@class ASIHTTPRequest;

@interface CheckinsViewController : CardViewController <UITableViewDelegate, UITableViewDataSource> {
  IBOutlet UITableView *_tableView;
  IBOutlet UIView *_filterView;
  
  ASIHTTPRequest *_checkinsRequest;
  NSArray *_responseArray;
  
  UIAlertView *_logoutAlert;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *filterView;

@property (nonatomic, retain) ASIHTTPRequest *checkinsRequest;
@property (nonatomic, retain) NSArray *responseArray;

- (void)getCheckins;

@end
