//
//  MeFriendsViewController.m
//  Moogle
//
//  Created by Peter Shih on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MeFriendsViewController.h"
#import "FriendCell.h"

static UIImage *_placeholderPicture = nil;

@implementation MeFriendsViewController

@synthesize rawFriendsArray = _rawFriendsArray;

+ (void)initialize {
  _placeholderPicture = [[UIImage imageNamed:@"friend_no_picture.png"] retain];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.frame = CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT_WITH_NAV);
  
  // Table
  [self setupTableViewWithFrame:self.view.frame andStyle:UITableViewStyleGrouped andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  
  self.tableView.allowsSelection = NO;
  
  [self setupLoadingAndEmptyViews];
  
  [self loadFriends];
}

// Subclasses may implement
- (void)setupLoadingAndEmptyViews {
  self.emptyView.hidden = YES;
  self.loadingView.hidden = YES;
}

- (void)loadFriends {
  [self.sections addObject:@"Friends"];
  
  // Friends
  [self.items addObject:self.rawFriendsArray];
  [self dataSourceDidLoad];
}

#pragma mark UITableView Stuff
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell_%d", [self class], indexPath.section];
  FriendCell *cell = nil;
  cell = (FriendCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[FriendCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
  }
  
  // Fill Cell
  NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  
  // Single Friends
  cell.textLabel.text = [item objectForKey:@"full_name"];
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [item objectForKey:@"checkins"]];
  
  cell.smaImageView.urlPath = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [item objectForKey:@"facebook_id"]];
  
  [cell.smaImageView loadImage];
  
  return cell;
}

- (void)dealloc {
  RELEASE_SAFELY(_rawFriendsArray);
  [super dealloc];
}

@end
