    //
//  WhoViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WhoViewController.h"
#import "Constants.h"

@interface WhoViewController (Private)

- (void)getPeople;

@end

@implementation WhoViewController

@synthesize tableView = _tableView;

@synthesize sections = _sections;
@synthesize items = _items;

@synthesize delegate = _delegate;

- (id)init {
  self = [super init];
  if (self) {
    _sections = [[NSMutableArray alloc] initWithCapacity:1];
    _items = [[NSMutableArray alloc] initWithCapacity:1];
  }
  return self;
}

- (void)loadView {
  [super loadView];
  self.view.frame = CGRectMake(0, 0, 320, 460);
  _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  [self.view addSubview:self.tableView];
  
  [self getPeople];
}

- (void)getPeople {
  NSArray *friends = [[NSUserDefaults standardUserDefaults] objectForKey:@"friends"];
  [self.sections addObject:@"Me"];
  [self.sections addObject:@"My Friends"];
  [self.sections addObject:@"Choose a Friend"];
  
  [self.items addObject:[NSArray arrayWithObject:@"me"]];
  [self.items addObject:[NSArray arrayWithObject:@"friends"]];
  [self.items addObject:friends];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  NSString *selected = nil;
  if([[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isKindOfClass:[NSNumber class]]) {
    selected = [[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] stringValue];
  } else {
    selected = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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
  UITableViewCell *cell = nil;
  cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier] autorelease];
  }
  
  if (indexPath.section == 0) {
    cell.textLabel.text = @"Me";
  } else if (indexPath.section == 1) {
    cell.textLabel.text = @"My Friends";
  } else {
    cell.textLabel.text = [[[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] stringValue];
  }

  return cell;
}

- (void)dealloc {
  RELEASE_SAFELY(_tableView);
  [super dealloc];
}

@end