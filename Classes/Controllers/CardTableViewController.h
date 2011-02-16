//
//  CardTableViewController.h
//  Prototype
//
//  Created by Peter Shih on 2/14/11.
//  Copyright 2011 LinkedIn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardViewController.h"

@interface CardTableViewController : CardViewController <UITableViewDelegate, UITableViewDataSource> {
  UITableView *_tableView;
  
  NSMutableArray *_sections;
  NSMutableArray *_items;
}

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableArray *items;

@end
