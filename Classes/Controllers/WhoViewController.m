    //
//  WhoViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WhoViewController.h"
#import "Constants.h"
#import "WhoCell.h"

@interface WhoViewController (Private)

- (void)getPeople;

@end

@implementation WhoViewController

@synthesize navigationBar = _navigationBar;
@synthesize dismissButtonTitle = _dismissButtonTitle;

@synthesize delegate = _delegate;

- (id)init {
  self = [super init];
  if (self) {
    _navigationBar = [[UINavigationBar alloc] init];
    _dismissButtonTitle = @"Cancel";
    self.title = @"Moogle";
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationBar.frame = CGRectMake(0, 0, 320, 44);
  
  // Setup Nav Items and Done button
  UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:self.title];
  UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:self.dismissButtonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
  navItem.rightBarButtonItem = dismissButton;
  [dismissButton release];
  [self.navigationBar setItems:[NSArray arrayWithObject:navItem]];
  [navItem release];
  
  [self.view addSubview:self.navigationBar];
  
  self.navigationBar.tintColor = MOOGLE_BLUE_COLOR;
  
  // Table
  [self setupTableViewWithFrame:CGRectMake(0, 44, 320, 416) andStyle:UITableViewStyleGrouped andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  
  [self getPeople];
}

- (void)dismiss {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)getPeople {
  NSArray *friends = [[NSUserDefaults standardUserDefaults] objectForKey:@"friends"];
  [self.sections addObject:@"Me"];
  [self.sections addObject:@"My Friends"];
  [self.sections addObject:@"Choose a Friend"];
  
  [self.items addObject:[NSArray arrayWithObject:[NSDictionary dictionaryWithObject:@"me" forKey:@"friend_name"]]];
  [self.items addObject:[NSArray arrayWithObject:[NSDictionary dictionaryWithObject:@"friends" forKey:@"friend_name"]]];
  [self.items addObject:friends];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  NSString *selected = nil;
  if (indexPath.section < 2) {
    selected = [[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"friend_name"];
  } else {
    selected = [[[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"friend_id"] stringValue];
  }
  
  if (self.delegate) {
    [self.delegate retain];
    if ([self.delegate respondsToSelector:@selector(whoPickedWithString:)]) {
      [self.delegate performSelector:@selector(whoPickedWithString:) withObject:selected];
    }
    [self.delegate release];
  }
  
  [self dismissModalViewControllerAnimated:YES];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[self.items objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell", [self class]];
  WhoCell *cell = nil;
  cell = (WhoCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[WhoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier] autorelease];
  }
  
  // Fill Cell
  NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  
  UIImage *image = nil;
  NSURL *url = nil;
  
  if ([[item objectForKey:@"friend_name"] isEqualToString:@"me"]) {

  } else if ([[item objectForKey:@"friend_name"] isEqualToString:@"friends"]) {
    
  } else {
    url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [item objectForKey:@"friend_id"]]];
    image = [self.imageCache getImageWithURL:url];
    if (!image) {
      if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
        [self.imageCache cacheImageWithURL:url forIndexPath:indexPath];
      }
      image = nil;
    }
  }
  
  [WhoCell fillCell:cell withDictionary:item withImage:image];

  return cell;
}

#pragma mark ImageCacheDelegate
- (void)loadImagesForOnScreenRows {
  NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
  
  for (NSIndexPath *indexPath in visibleIndexPaths) {
    NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSURL *url = nil;
    
    if ([[item objectForKey:@"friend_name"] isEqualToString:@"me"]) {
      
    } else if ([[item objectForKey:@"friend_name"] isEqualToString:@"friends"]) {
      
    } else {
      url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [item objectForKey:@"friend_id"]]];
      if (![self.imageCache getImageWithURL:url]) {
        [self.imageCache cacheImageWithURL:url forIndexPath:indexPath];
      }
    }
  }
}

- (void)dealloc {
  RELEASE_SAFELY(_dismissButtonTitle);
  RELEASE_SAFELY(_navigationBar);
  [super dealloc];
}

@end