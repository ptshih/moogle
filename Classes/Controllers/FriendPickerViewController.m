//
//  FriendPickerViewController.m
//  Moogle
//
//  Created by Peter Shih on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FriendPickerViewController.h"
#import "FriendCell.h"

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
  
  self.view.frame = CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT_WITH_NAV + 49.0);
  
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
  self.navigationItem.leftBarButtonItem = backButton;
  [backButton release];
  
  // Table
  [self setupTableViewWithFrame:self.view.frame andStyle:UITableViewStyleGrouped andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  
  [self setupLoadingAndEmptyViews];
  
  [self getFriends];
}

// Subclasses may implement
- (void)setupLoadingAndEmptyViews {
  self.emptyView.hidden = YES;
  self.loadingView.hidden = YES;
}

- (void)dismiss {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)back {
  // OPTIMIZE
  NSString *selectedIds = nil;
  NSString *selectedNames = nil;
  NSMutableArray *selectedIdsArray = [NSMutableArray array];
  NSMutableArray *selectedNamesArray = [NSMutableArray array];
  
  for (NSDictionary *selectedDict in [self.selectedDict allValues]) {
    [selectedIdsArray addObject:[selectedDict objectForKey:@"friend_id"]];
    [selectedNamesArray addObject:[selectedDict objectForKey:@"friend_name"]]; 
  }
  
  if ([selectedIdsArray count] > 0) {
    selectedIds = [selectedIdsArray componentsJoinedByString:@","];
    selectedNames = [selectedNamesArray componentsJoinedByString:@", "];
    
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
  }
  
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)getFriends {
  [self.sections addObject:@"Friends"];
  
  // Friends
  NSArray *friends = [[NSUserDefaults standardUserDefaults] objectForKey:@"friends"];
  _sortedFriends = [[friends sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"friend_name" ascending:YES]]] retain];
  [self.items addObject:_sortedFriends];
  [self dataSourceDidLoad];
}

#pragma mark UITableView Stuff
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell_%d", [self class], indexPath.section];
  FriendCell *cell = nil;
  cell = (FriendCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
  }
  
  // Fill Cell
  NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  
  if ([self.selectedDict objectForKey:indexPath]) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  // Single Friends
  cell.textLabel.text = [item objectForKey:@"friend_name"];
  
  cell.smaImageView.urlPath = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [item objectForKey:@"friend_id"]];

  [cell.smaImageView loadImage];
  
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

- (void)dealloc {
  RELEASE_SAFELY(_selectedDict);
  [super dealloc];
}

@end
