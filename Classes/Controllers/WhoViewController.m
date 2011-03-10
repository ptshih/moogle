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
    
    _fpvc = [[FriendPickerViewController alloc] init];
    _fpvc.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.frame = CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT_WITH_NAV + 49.0);
  
  UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
  self.navigationItem.leftBarButtonItem = dismissButton;
  [dismissButton release];
  
  // Table
  [self setupTableViewWithFrame:self.view.frame andStyle:UITableViewStyleGrouped andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  
  [self setupLoadingAndEmptyViews];
  [self getPeople];
}

// Subclasses may implement
- (void)setupLoadingAndEmptyViews {
  self.emptyView.hidden = YES;
  self.loadingView.hidden = YES;
}

- (void)dismiss {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)reloadDataSource {
  [self.sections removeAllObjects];
  [self.items removeAllObjects];
  [self getPeople];
  [self.tableView reloadData];
  [self dataSourceDidLoad];
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
  
  [self dataSourceDidLoad];
}

- (void)selectGroupAtIndex:(NSInteger)index {
  if (self.delegate) {
    [self.delegate retain];
    if ([self.delegate respondsToSelector:@selector(friendPickedWithFriendIds:)]) {
      // Tell delegate which group we selected
      [self.delegate performSelector:@selector(friendPickedWithFriendIds:) withObject:[[_sortedGroups objectAtIndex:index] objectForKey:@"group_id"]];
    }
    [self.delegate release];
  }
  
  [self dismiss];
}

- (void)selectFriendAtIndex:(NSInteger)index {
  if (self.delegate) {
    [self.delegate retain];
    if ([self.delegate respondsToSelector:@selector(friendPickedWithFriendIds:)]) {
      // Tell delegate which group we selected
      [self.delegate performSelector:@selector(friendPickedWithFriendIds:) withObject:[[[_sortedFriends objectAtIndex:index] objectForKey:@"friend_id"] stringValue]];
    }
    [self.delegate release];
  }
  
  [self dismiss];
}
                             
- (void)createGroup {
  [self.navigationController pushViewController:_fpvc animated:YES];
}

#pragma mark FriendPickerDelegate
- (void)friendPickedWithFriendIds:(NSString *)friendIds {
  // Create a new group for these friends
  NSArray *savedGroups = [[NSUserDefaults standardUserDefaults] objectForKey:@"groups"];
  NSDictionary *newGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"New Group", @"group_name", friendIds, @"group_id", nil];
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
  WhoCell *cell = nil;
  cell = (WhoCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[WhoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
  }
  
  // Fill Cell
  NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  
  if (indexPath.section == 0) {
    // Groups
    [WhoCell fillCell:cell withDictionary:item forType:WhoCellTypeGroup];
    
    if (indexPath.row == [_sortedGroups count] - 1) {
      // last section is add a group
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
      cell.accessoryType = UITableViewCellAccessoryNone;
    }
  } else {
    // Single Friends
    [WhoCell fillCell:cell withDictionary:item forType:WhoCellTypeFriend];
  }

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

- (void)dealloc {
  RELEASE_SAFELY(_fpvc);
  RELEASE_SAFELY(_sortedFriends);
  RELEASE_SAFELY(_sortedGroups);
  [super dealloc];
}

@end