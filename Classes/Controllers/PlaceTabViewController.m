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
@synthesize viewport = _viewport;

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
}

- (void)dealloc {
  RELEASE_SAFELY(_dataCenter);
  [super dealloc];
}

@end
