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
#import "HeaderTabView.h"
#import "EGORefreshTableHeaderView.h"
#import "HeaderTabViewDelegate.h"

@interface CardTableViewController : CardViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate, ImageCacheDelegate, EGORefreshTableHeaderDelegate, HeaderTabViewDelegate> {
  UITableView *_tableView;
  NSMutableArray *_sections;
  NSMutableArray *_items;
  NSMutableArray *_searchItems;
  
  ImageCache *_imageCache;

  UISearchBar *_searchBar;
  HeaderTabView *_headerTabView;
  EGORefreshTableHeaderView *_refreshHeaderView;
  BOOL _reloading;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSMutableArray *searchItems;

@property (nonatomic, retain) ImageCache *imageCache;
@property (nonatomic, retain) HeaderTabView *headerTabView;

- (void)setupTableViewWithFrame:(CGRect)frame andStyle:(UITableViewStyle)style andSeparatorStyle:(UITableViewCellSeparatorStyle)separatorStyle;
- (void)setupPullRefresh;
- (void)setupHeaderTabView;
- (void)setupSearchDisplayController;

@end
