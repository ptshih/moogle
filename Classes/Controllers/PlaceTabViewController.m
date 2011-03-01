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
@synthesize placeId = _placeId;
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

// SUBCLASS NEEDS TO IMPLEMENT
- (void)reloadDataSource {
}

- (void)dealloc {
  RELEASE_SAFELY(_dataCenter);
  RELEASE_SAFELY(_placeId);
  [super dealloc];
}

@end
