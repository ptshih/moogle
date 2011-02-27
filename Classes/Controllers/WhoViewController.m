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

@synthesize delegate = _delegate;

- (id)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.frame = CGRectMake(0, 0, 320, 460);
  
  // Table
  [self setupTableViewWithFrame:self.view.frame andStyle:UITableViewStyleGrouped andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  
  [self getPeople];
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
  UIImage *whoImage = nil;
  
  if ([[item objectForKey:@"friend_name"] isEqualToString:@"me"]) {
    
  } else if ([[item objectForKey:@"friend_name"] isEqualToString:@"friends"]) {
    
  } else {
    whoImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [item objectForKey:@"friend_id"]]]]];
  }
  
  [WhoCell fillCell:cell withDictionary:item withImage:whoImage];
  
//  if (indexPath.section == 0) {
//    cell.textLabel.text = @"Me";
//  } else if (indexPath.section == 1) {
//    cell.textLabel.text = @"My Friends";
//  } else {
//    // Friends array
//    cell.textLabel.text = [[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"friend_name"];
//    cell.detailTextLabel.text = [[[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"friend_id"] stringValue];
//  }

  return cell;
}

- (void)dealloc {
  [super dealloc];
}

@end