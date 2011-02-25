//
//  CardTableViewController.h
//  Prototype
//
//  Created by Peter Shih on 2/14/11.
//  Copyright 2011 LinkedIn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardViewController.h"
#import "ImageCacheDelegate.h"
#import "ImageCache.h"

@interface CardTableViewController : CardViewController <UITableViewDelegate, UITableViewDataSource, ImageCacheDelegate> {
  UITableView *_tableView;
  
  NSMutableArray *_sections;
  NSMutableArray *_items;
  
  ImageCache *_imageCache;
}

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableArray *items;

@property (nonatomic, retain) ImageCache *imageCache;

@end
