//
//  PlaceInfoViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceInfoViewController.h"
#import "PlaceInfoCell.h"

@interface PlaceInfoViewController (Private)

- (void)setupViews;
- (UIImage *)starImageForRating:(NSString *)rating;

@end

@implementation PlaceInfoViewController
@synthesize placeNameLabel = _placeNameLabel;
@synthesize placeAddressLabel = _placeAddressLabel;
@synthesize reviewsLabel = _reviewsLabel;
@synthesize starsImageView = _starsImageView;

- (id)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
//  self.tableView.frame = CGRectMake(0, 98, 320, 225);

//  [self setupViews];
  
  [self loadPlaceInfo];
}

- (void)setupViews {

//  _infoView.layer.cornerRadius = 10.0;
//  _infoView.layer.borderWidth = 1.0;
//  _infoView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (UIImage *)starImageForRating:(NSString *)rating {
  CGFloat rawRating = [rating floatValue];
  NSString *starImageString = [NSString stringWithFormat:@"stars_%.1f.png", rawRating];
  
  return [UIImage imageNamed:starImageString];
}

- (void)reloadPlaceInfo {
  [self.sections removeAllObjects];
  [self.items removeAllObjects];
  [self loadPlaceInfo];
}

- (void)loadPlaceInfo {
  self.placeNameLabel.text = self.place.placeName;
  if ([self.place.placeStreet notNil] && [self.place.placeCity notNil] && [self.place.placeState notNil] && [self.place.placeZip notNil]) {
    self.placeAddressLabel.text = [NSString stringWithFormat:@"%@ %@, %@ %@", self.place.placeStreet, self.place.placeCity, self.place.placeState, self.place.placeZip];
  } else {
    self.placeAddressLabel.text = @"No Address Found";
  }
  
  if ([self.place.placeReviews notNil]) {
    self.reviewsLabel.text = [NSString stringWithFormat:@"%@ Reviews", self.place.placeReviews];
  } else {
    self.reviewsLabel.text = @"No Reviews Found";
  }
  
  if ([self.place.placeRating notNil]) {
    self.starsImageView.image = [self starImageForRating:self.place.placeRating];
  } else {
    self.starsImageView.image = [UIImage imageNamed:@"stars_0.png"];
  }
  
  [self.sections addObject:@"Place Info"];
  
  // Place Info Section
  NSMutableArray *placeInfoArray = [NSMutableArray array];
  [placeInfoArray addObject:@"Info Placeholder"];
  
  if ([self.place.placePhone notNil]) {
    [placeInfoArray addObject:[NSDictionary dictionaryWithObject:self.place.placePhone forKey:@"Phone"]];
  }
  if ([self.place.placeWebsite notNil]) {
    [placeInfoArray addObject:[NSDictionary dictionaryWithObject:self.place.placeWebsite forKey:@"Website"]];
  }
  if ([self.place.placePrice notNil]) {
    [placeInfoArray addObject:[NSDictionary dictionaryWithObject:self.place.placePrice forKey:@"Price"]];
  }

  [self.items addObject:placeInfoArray];
  
  if ([self.place.placeTerms notNil]) {
    // Place Yelp Terms Section
    [self.sections addObject:@"What People Are Saying"];
    
    NSMutableArray *placeTermsArray = [NSMutableArray array];
  
    [placeTermsArray addObject:self.place.placeTerms];
    
    [self.items addObject:placeTermsArray];
  }
  
  
//  if (self.place.placeCategories) {
//    [placeYelpArray addObject:self.place.placeCategories];
//  }
  
  [self updateState];
}

#pragma mark CardStateMachine
- (BOOL)dataIsAvailable {
  return YES;
}

- (BOOL)dataSourceIsReady {
  return YES;
}

#pragma mark UITableViewDelegate
#pragma mark UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0 && indexPath.row == 0) {
    return 100.0;
  } else if (indexPath.section == 1) {
    return [MoogleCell variableRowHeightWithText:self.place.placeTerms andFontSize:14.0];
  } else {
    return 44.0;
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 1) {
    return [self.sections objectAtIndex:section];
  } else {
    return nil;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PlaceInfoCell *cell = nil;
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell_%d", [self class], indexPath.section];
  
  cell = (PlaceInfoCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[PlaceInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
  }
  
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      [cell.contentView addSubview:_infoView];
    } else {
      NSDictionary *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
      cell.textLabel.text = [[item allKeys] objectAtIndex:0];
      cell.detailTextLabel.text = [[item allValues] objectAtIndex:0];
    }
  } else {
    cell.textLabel.text = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 10;
  }
  
  return cell;
}

- (void)dealloc {
  RELEASE_SAFELY(_placeImage);

  [super dealloc];
}

- (void)viewDidUnload {
  [self setPlaceNameLabel:nil];
  [self setPlaceAddressLabel:nil];
  [self setReviewsLabel:nil];
  [self setStarsImageView:nil];
  [super viewDidUnload];
}
@end
