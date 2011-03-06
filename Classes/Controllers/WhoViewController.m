//
//  WhoViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WhoViewController.h"
#import "WhoCell.h"
#import "FriendPickerViewController.h"

static UIImage *_placeholderPicture;

@interface WhoViewController (Private)

- (void)reloadDataSource;
- (void)getPeople;
- (void)createGroup;
- (void)selectGroupAtIndex:(NSInteger)index;
- (void)selectFriendAtIndex:(NSInteger)index;

@end

@implementation WhoViewController

@synthesize delegate = _delegate;

+ (void)initialize {
  _placeholderPicture = [[UIImage imageNamed:@"friend_no_picture.png"] retain];
}

- (id)init {
  self = [super init];
  if (self) {
    self.title = @"Filter Feed";
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
  self.navigationItem.leftBarButtonItem = dismissButton;
  [dismissButton release];
  
  // Table
  [self setupTableViewWithFrame:CGRectMake(0, 0, 320, CARD_HEIGHT_WITH_NAV + 49.0) andStyle:UITableViewStyleGrouped andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  
  [self getPeople];
}

- (void)dismiss {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)reloadDataSource {
  [self.sections removeAllObjects];
  [self.items removeAllObjects];
  [self getPeople];
  [self.tableView reloadData];
}

- (void)getPeople {
  [self.sections addObject:@"Groups"];
  [self.sections addObject:@"Friends"];
  
  // Groups
  // Me and Friends default groups
  _sortedGroups = [[NSMutableArray array] retain];
  NSDictionary *meGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"My Feed", @"group_name", @"me", @"group_id", nil];
  NSDictionary *friendsGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"Friend Feed", @"group_name", @"friends", @"group_id", nil];
  [_sortedGroups addObject:meGroup];
  [_sortedGroups addObject:friendsGroup];
  
  // Saved Groups IF any
  NSArray *savedGroups = [[NSUserDefaults standardUserDefaults] objectForKey:@"groups"];
  if (savedGroups) {
    [_sortedGroups addObjectsFromArray:savedGroups];
  }
  
  // Create a group
  [_sortedGroups addObject:[NSDictionary dictionaryWithObject:@"Create a New Group" forKey:@"group_name"]];
  [self.items addObject:_sortedGroups];
  
  // Friends
  NSArray *friends = [[NSUserDefaults standardUserDefaults] objectForKey:@"friends"];
  _sortedFriends = [[friends sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"friend_name" ascending:YES]]] retain];
  [self.items addObject:_sortedFriends];
}

- (void)selectGroupAtIndex:(NSInteger)index {
  if (self.delegate) {
    [self.delegate retain];
    if ([self.delegate respondsToSelector:@selector(friendPickedWithString:)]) {
      // Tell delegate which group we selected
      [self.delegate performSelector:@selector(friendPickedWithString:) withObject:[[_sortedGroups objectAtIndex:index] objectForKey:@"group_id"]];
    }
    [self.delegate release];
  }
  
  [self dismiss];
}

- (void)selectFriendAtIndex:(NSInteger)index {
  if (self.delegate) {
    [self.delegate retain];
    if ([self.delegate respondsToSelector:@selector(friendPickedWithString:)]) {
      // Tell delegate which group we selected
      [self.delegate performSelector:@selector(friendPickedWithString:) withObject:[[[_sortedFriends objectAtIndex:index] objectForKey:@"friend_id"] stringValue]];
    }
    [self.delegate release];
  }
  
  [self dismiss];
}
                             
- (void)createGroup {
  FriendPickerViewController *fpvc = [[FriendPickerViewController alloc] init];
  fpvc.delegate = self;
  [self.navigationController pushViewController:fpvc animated:YES];
  [fpvc release];
}

#pragma mark FriendPickerDelegate
- (void)friendPickedWithString:(NSString *)friends {
  // Create a new group for these friends
  NSArray *savedGroups = [[NSUserDefaults standardUserDefaults] objectForKey:@"groups"];
  NSDictionary *newGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"New Group", @"group_name", friends, @"group_id", nil];
  NSMutableArray *newSavedGroups = [NSMutableArray arrayWithArray:savedGroups];
  [newSavedGroups addObject:newGroup];
  [[NSUserDefaults standardUserDefaults] setObject:newSavedGroups forKey:@"groups"];
  [self reloadDataSource];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  if (indexPath.section == 0) {
    if (indexPath.row == [_sortedGroups count] - 1) {
      [self createGroup];
    } else {
      [self selectGroupAtIndex:indexPath.row];
    }
  } else {
    [self selectFriendAtIndex:indexPath.row];
  }
}

#pragma mark UITableViewDataSource
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
  
  if (indexPath.section == 0) {
    // Groups
    image = [UIImage imageNamed:@"tab_friends.png"]; // placeholder groups image
    cell.textLabel.text = [item objectForKey:@"group_name"];
    if (indexPath.row == [_sortedGroups count] - 1) {
      // last section is add a group
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
      cell.accessoryType = UITableViewCellAccessoryNone;
    }
  } else {
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
  }

  cell.imageView.image = image;

  return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0 && indexPath.row > 1 && (indexPath.row < [_sortedGroups count] - 1)) {
      return UITableViewCellEditingStyleDelete;
  } else {
      return UITableViewCellEditingStyleNone;
  }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Remove this group
    NSMutableArray *savedGroups = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"groups"]];
    [savedGroups removeObjectAtIndex:indexPath.row - 2]; // -2 for the me/friends grps
    [[NSUserDefaults standardUserDefaults] setObject:savedGroups forKey:@"groups"];
    
    
    
    [tableView beginUpdates];
    
    [self.sections removeAllObjects];
    [self.items removeAllObjects];
    [self getPeople];
    
//    if ([tableView numberOfRowsInSection:indexPath.section] <= 1) {
//      [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
//    }
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
  }
}

#pragma mark ImageCacheDelegate
- (void)loadImagesForOnScreenRows {
  NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
  
  for (NSIndexPath *indexPath in visibleIndexPaths) {
    NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSURL *url = nil;
    
    // Only cache images for section 1 (friends)
    if (indexPath.section == 1) {
      url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [item objectForKey:@"friend_id"]]];
      if (![self.imageCache getImageWithURL:url]) {
        [self.imageCache cacheImageWithURL:url forIndexPath:indexPath];
      }
    }
  }
}

- (void)dealloc {
  RELEASE_SAFELY(_sortedFriends);
  RELEASE_SAFELY(_sortedGroups);
  [super dealloc];
}

@end