//
//  FriendPickerViewController.m
//  Moogle
//
//  Created by Peter Shih on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FriendPickerViewController.h"

static UIImage *_placeholderPicture;

@interface FriendPickerViewController (Private)

- (void)getFriends;

@end

@implementation FriendPickerViewController

@synthesize delegate = _delegate;
@synthesize selectedDict = _selectedDict;

+ (void)initialize {
  _placeholderPicture = [[UIImage imageNamed:@"friend_no_picture.png"] retain];
}

- (id)init {
  self = [super init];
  if (self) {
    _selectedDict = [[NSMutableDictionary alloc] init];
    self.title = @"Choose Friends";
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
  self.navigationItem.rightBarButtonItem = doneButton;
  [doneButton release];
  
  // Table
  [self setupTableViewWithFrame:CGRectMake(0, 0, 320, CARD_HEIGHT_WITH_NAV + 49.0) andStyle:UITableViewStyleGrouped andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  
  [self getFriends];
}

- (void)dismiss {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)done {
  // OPTIMIZE
  NSString *selectedIds = nil;
  NSString *selectedNames = nil;
  NSMutableArray *selectedIdsArray = [NSMutableArray array];
  NSMutableArray *selectedNamesArray = [NSMutableArray array];

  for (NSDictionary *selectedDict in [self.selectedDict allValues]) {
    [selectedIdsArray addObject:[selectedDict objectForKey:@"friend_id"]];
    [selectedNamesArray addObject:[selectedDict objectForKey:@"friend_name"]]; 
  }
  
  if ([selectedIdsArray count] > 1) {
    selectedIds = [selectedIdsArray componentsJoinedByString:@","];
    selectedNames = [selectedNamesArray componentsJoinedByString:@","];
  } else if ([selectedIdsArray count] > 0) {
    selectedIds = [[[selectedIdsArray objectAtIndex:0] objectForKey:@"friend_id"] stringValue];
    selectedNames = [[[selectedIdsArray objectAtIndex:0] objectForKey:@"friend_name"] stringValue];
  } else {
    // EPIC FAIL, NEED TO SELECT AT LEAST ONE
    UIAlertView *doneAlert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"You need to select at least one friend!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [doneAlert show];
    [doneAlert autorelease];
    return;
  }
  
  if (self.delegate) {
    [self.delegate retain];
    if ([self.delegate respondsToSelector:@selector(friendPickedWithFriendIds:)]) {
      [self.delegate performSelector:@selector(friendPickedWithFriendIds:) withObject:selectedIds];
    }
    if ([self.delegate respondsToSelector:@selector(friendPickedWithFriendNames:)]) {
      [self.delegate performSelector:@selector(friendPickedWithFriendNames:) withObject:selectedNames];
    }
    [self.delegate release];
  }
  
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)getFriends {
  [self.sections addObject:@"Friends"];
  
  // Friends
  NSArray *friends = [[NSUserDefaults standardUserDefaults] objectForKey:@"friends"];
  _sortedFriends = [[friends sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"friend_name" ascending:YES]]] retain];
  [self.items addObject:_sortedFriends];
}

#pragma mark UITableView Stuff
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell_%d", [self class], indexPath.section];
  UITableViewCell *cell = nil;
  cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
  }
  
  // Fill Cell
  NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  
  UIImage *image = nil;
  NSURL *url = nil;
  
  if ([self.selectedDict objectForKey:indexPath]) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  // Single Friends
  cell.textLabel.text = [item objectForKey:@"friend_name"];
  url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [item objectForKey:@"friend_id"]]];
  image = [self.imageCache getImageWithURL:url];
  if (!image) {
    if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
      [self.imageCache cacheImageWithURL:url forIndexPath:indexPath];
    }
    image = _placeholderPicture;
  }
  
  cell.imageView.image = image;
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
    cell.accessoryType = UITableViewCellAccessoryNone;
    [self.selectedDict removeObjectForKey:indexPath];
  } else {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self.selectedDict setObject:[_sortedFriends objectAtIndex:indexPath.row] forKey:indexPath];
  }
}

#pragma mark ImageCacheDelegate
- (void)loadImagesForOnScreenRows {
  NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
  
  for (NSIndexPath *indexPath in visibleIndexPaths) {
    NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSURL *url = nil;
    
    url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [item objectForKey:@"friend_id"]]];
    if (![self.imageCache getImageWithURL:url]) {
      [self.imageCache cacheImageWithURL:url forIndexPath:indexPath];
    }
  }
}

- (void)dealloc {
  RELEASE_SAFELY(_selectedDict);
  [super dealloc];
}

@end
