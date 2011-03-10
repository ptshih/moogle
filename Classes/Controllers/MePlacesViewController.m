//
//  MePlacesViewController.m
//  Moogle
//
//  Created by Peter Shih on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MePlacesViewController.h"

@implementation MePlacesViewController

@synthesize rawPlacesArray = _rawPlacesArray;
@synthesize topPlacesArray = _topPlacesArray;

- (id)init {
  self = [super init];
  if (self) {
    _topPlacesArray = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"Top Places";
  
  // Table
  CGRect tableFrame = CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT_WITH_NAV);
  [self setupTableViewWithFrame:tableFrame andStyle:UITableViewStylePlain andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  
  [self getTopPlaces];
}

- (void)getTopPlaces {
  // Serialize all the places in the array
  for (NSDictionary *placeDict in self.rawPlacesArray) {
    Place *newPlace = [[Place alloc] initWithDictionary:placeDict];
    [self.topPlacesArray addObject:newPlace];
    [newPlace release];
  }
  
  
  [self.sections removeAllObjects];
  [self.sections addObject:@"Top Places"];
  
  [self.items removeAllObjects];
  [self.items addObject:self.topPlacesArray];
  [self.tableView reloadData];
  [self dataSourceDidLoad];
}

- (void)dealloc {
  RELEASE_SAFELY(_rawPlacesArray);
  RELEASE_SAFELY(_topPlacesArray);
  [super dealloc];
}

@end
