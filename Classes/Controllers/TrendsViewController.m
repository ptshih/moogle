//
//  TrendsViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TrendsViewController.h"
#import "Constants.h"

#import "ASIHTTPRequest.h"
#import "RemoteRequest.h"
#import "RemoteOperation.h"

#import "CJSONDeserializer.h"

#import "NSDate+HumanInterval.h"

@interface TrendsViewController (Private)

- (void)setupButtons;

@end

@implementation TrendsViewController

@synthesize tableView = _tableView;
@synthesize filterView = _filterView;

@synthesize trendsRequest = _trendsRequest;
@synthesize responseArray = _responseArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _responseArray = [[NSArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationController.navigationBar.tintColor = FB_COLOR_DARK_BLUE;
  self.title = @"Moogle Trends";
  
  self.filterView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"filter_gradient.png"]];
  
  [self setupButtons];
}

- (void)setupButtons {
  // Setup Filter button
  UIBarButtonItem *filterButton = [[[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleBordered target:self action:@selector(filter)] autorelease];
  self.navigationItem.rightBarButtonItem = filterButton;
}

- (void)animateShowFilter {
  [UIView beginAnimations:@"ShowFilter" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];  
	[UIView setAnimationDuration:0.3]; // Fade out is configurable in seconds (FLOAT)
  self.filterView.top = 0.0;
  self.tableView.frame = CGRectMake(0, 44.0, self.tableView.width, self.tableView.height - 44.0);
  //  self.tableView.contentInset = UIEdgeInsetsMake(44.0, 0.0, 0.0, 0.0);
	[UIView commitAnimations];
}

- (void)animateHideFilter {
  [UIView beginAnimations:@"HideFilter" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];  
	[UIView setAnimationDuration:0.3]; // Fade out is configurable in seconds (FLOAT)
  self.filterView.top = -44.0;
  self.tableView.frame = CGRectMake(0, 0, self.tableView.width, self.tableView.height + 44.0);
	[UIView commitAnimations];
}

#pragma mark CardViewController
- (void)reloadCardController {
  [super reloadCardController];
  
}



#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  [self showPlaceWithId:[[self.responseArray objectAtIndex:indexPath.row] objectForKey:@"place_id"]];
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.responseArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  cell = [tableView dequeueReusableCellWithIdentifier:@"CheckinCell"];
  if(cell == nil) { 
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CheckinCell"] autorelease];
    cell.textLabel.numberOfLines = 100;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell_bg.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"table_cell_bg_selected.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:20]];
  }
  
  cell.textLabel.text = [[self.responseArray objectAtIndex:indexPath.row] objectForKey:@"name"];
  cell.detailTextLabel.text = [[self.responseArray objectAtIndex:indexPath.row] objectForKey:@"place_name"];
  
  //  NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[self.responseArray objectAtIndex:indexPath.row] objectForKey:@"checkin_timestamp"] intValue]];
  //  cell.detailTextLabel.text = [date humanIntervalSinceNow];
  
  return cell;
}


- (void)dealloc {
    [super dealloc];
}


@end
