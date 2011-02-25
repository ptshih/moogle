    //
//  CardTableViewController.m
//  Prototype
//
//  Created by Peter Shih on 2/14/11.
//  Copyright 2011 LinkedIn. All rights reserved.
//

#import "CardTableViewController.h"
#import "Constants.h"

@interface CardTableViewController (Private)

- (void)loadImagesForOnScreenRows;

@end

@implementation CardTableViewController

@synthesize tableView = _tableView;

@synthesize sections = _sections;
@synthesize items = _items;

@synthesize imageCache = _imageCache;

- (id)init {
  self = [super init];
  if (self) {
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _sections = [[NSMutableArray alloc] initWithCapacity:1];
    _items = [[NSMutableArray alloc] initWithCapacity:1];
    
    _imageCache = [[ImageCache alloc] init];
    _imageCache.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.frame = self.view.frame;
  [self.view addSubview:self.tableView];
}

// Called when the user logs out and we need to clear all cached data
// Subclasses should override this method
- (void)clearCachedData {
  [self.sections removeAllObjects];
  [self.items removeAllObjects];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[self.items objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell", [self class]];
  UITableViewCell *cell = nil;
  cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier] autorelease];
  }
  
  cell.textLabel.text = @"Oops! Forgot to override this method?";
  cell.detailTextLabel.text = reuseIdentifier;
  return cell;
}

#pragma mark ImageCacheDelegate
- (void)imageDidLoad:(NSIndexPath *)indexPath {
  [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  if (!decelerate) {
    [self loadImagesForOnScreenRows];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [self loadImagesForOnScreenRows];
}

- (void)loadImagesForOnScreenRows {
  // Subclass
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  [self.imageCache resetCache];
}

- (void)dealloc {
  RELEASE_SAFELY(_tableView);
  RELEASE_SAFELY(_imageCache);
  [super dealloc];
}

@end