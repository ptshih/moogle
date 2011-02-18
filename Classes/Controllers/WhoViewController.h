//
//  WhoViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhoFilterDelegate.h"

@interface WhoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
  UITableView *_tableView;
  
  NSMutableArray *_sections;
  NSMutableArray *_items;
  
  id <WhoFilterDelegate> _delegate;
}

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableArray *items;

@property (nonatomic, assign) id <WhoFilterDelegate> delegate;

@end
