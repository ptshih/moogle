//
//  CardPlacesTableViewController.m
//  Moogle
//
//  Created by Peter Shih on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CardPlacesTableViewController.h"

@implementation CardPlacesTableViewController

@synthesize dataCenter = _dataCenter;

- (id)init {
  self = [super init];
  if (self) {
    _dataCenter = [[PlacesDataCenter alloc] init];
    _dataCenter.delegate = self;
    _distance = [@"25" retain]; // default to 100 miles
  }
  return self;
}

- (void)setupDistanceButton {
  //  _distanceButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn-distance.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(toggleDistance)];
  
  _distanceButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%@ miles", _distance] style:UIBarButtonItemStyleBordered target:self action:@selector(toggleDistance)];
  self.navigationItem.rightBarButtonItem = _distanceButton;
}

#pragma mark Show Place
- (void)showPlaceForPlace:(Place *)place {
  PlaceViewController *pvc = [[PlaceViewController alloc] init];
  pvc.place = place;
  [self.navigationController pushViewController:pvc animated:YES];
  [pvc release];  
}

#pragma mark MoogleDataCenterDelegate
- (void)dataCenterDidFinish:(ASIHTTPRequest *)request {
  [self.sections removeAllObjects];
  [self.sections addObject:@"Places"];
  
  [self.items removeAllObjects];
  [self.items addObject:self.dataCenter.placesArray];
  [self.tableView reloadData];
  [self dataSourceDidLoad];
}

- (void)dataCenterDidFail:(ASIHTTPRequest *)request {
  [self dataSourceDidLoad];
}


#pragma mark UITableView Stuff
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [PlaceCell rowHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  Place *place = nil;
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    place = [[self.searchItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  } else {
    place = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  }
  
  [self showPlaceForPlace:place];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PlaceCell *cell = nil;
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell_%d", [self class], indexPath.section];
  
  cell = (PlaceCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if(cell == nil) { 
    cell = [[[PlaceCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier] autorelease];
  }
  
  Place *place = nil;
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    place = [[self.searchItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  } else {
    place = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  }
  
  [PlaceCell fillCell:cell withPlace:place withImage:nil];
  
  // Initial static render of cell
  if (tableView.dragging == NO && tableView.decelerating == NO) {
    [cell.smaImageView loadImage];
  }
  
  return cell;
}

#pragma mark UISearchDisplayDelegate
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
  // SUBCLASS MUST IMPLEMENT
  [self.searchItems removeAllObjects];
  
  for (NSArray *section in self.items) {
    [self.searchItems addObject:[NSMutableArray array]];
    for (Place *place in section) {
      NSComparisonResult result = [place.placeName compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
      if (result == NSOrderedSame) {
        [[self.searchItems lastObject] addObject:place];
      }
    }
  }
}

- (void)dealloc {
  RELEASE_SAFELY (_dataCenter);
  RELEASE_SAFELY(_distance);
  RELEASE_SAFELY(_distanceButton);
  [super dealloc];
}

@end
