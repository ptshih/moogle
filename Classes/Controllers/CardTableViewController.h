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
#import "EGORefreshTableHeaderView.h"

@interface CardTableViewController : CardViewController <UITableViewDelegate, UITableViewDataSource, ImageCacheDelegate, EGORefreshTableHeaderDelegate> {
  UITableView *_tableView;
  
  NSMutableArray *_sections;
  NSMutableArray *_items;
  
  ImageCache *_imageCache;
  
  EGORefreshTableHeaderView *_refreshHeaderView;
}

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableArray *items;

@property (nonatomic, retain) ImageCache *imageCache;

@end
