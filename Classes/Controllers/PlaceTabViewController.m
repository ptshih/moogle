//
//  PlaceTabViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceTabViewController.h"

@implementation PlaceTabViewController

@synthesize dataCenter = _dataCenter;
@synthesize place = _place;

- (id)init {
  self = [super init];
  if (self) {
    _dataCenter = [[PlaceDataCenter alloc] init];
    _dataCenter.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.frame = CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT_WITH_NAV - 44);
  [self setupLoadingAndEmptyViews];
  
  // Table
  [self setupTableViewWithFrame:self.view.frame andStyle:UITableViewStyleGrouped andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  
  self.loadingLabel.textColor = MOOGLE_BLUE_COLOR;
  self.loadingSpinner.top = self.view.center.y + 20;
}

// Subclasses may implement
- (void)setupLoadingAndEmptyViews {
  self.emptyView.frame = self.view.frame;
  self.loadingView.frame = self.view.frame;
  self.emptyView.backgroundColor = [UIColor groupTableViewBackgroundColor];
  self.loadingView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)dealloc {
  RELEASE_SAFELY(_dataCenter);
  [super dealloc];
}

@end
