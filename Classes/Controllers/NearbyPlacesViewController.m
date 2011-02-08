//
//  NearbyPlacesViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NearbyPlacesViewController.h"
#import "PlaceViewController.h"
#import "Constants.h"
#import "LocationManager.h"

#import "ASIHTTPRequest.h"
#import "RemoteRequest.h"
#import "RemoteOperation.h"

#import "CJSONDeserializer.h"
#import "CJSONDataSerializer.h"

@implementation NearbyPlacesViewController

@synthesize tableView = _tableView;
@synthesize nearbyPlacesRequest = _nearbyPlacesRequest;
@synthesize responseArray = _responseArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _responseArray = [[NSArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNearbyPlaces) name:kLocationAcquired object:nil];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
//  self.navigationController.navigationBar.tintColor = FB_COLOR_DARK_BLUE;
//  self.title = @"Nearby Places";
  
//  [self getNearbyPlaces];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

}

- (void)getNearbyPlaces {
  CGFloat lat = [APP_DELEGATE.locationManager latitude];
  CGFloat lng = [APP_DELEGATE.locationManager longitude];
  CGFloat distance = [APP_DELEGATE.locationManager distance];
  NSString *query = @"";
  
  DLog(@"requesting nearby facebook places at lat: %f, lng: %f, distance: %f", lat, lng, distance);
  
  NSDictionary *postJson = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:lat], @"lat", [NSNumber numberWithFloat:lng], @"lng", [NSNumber numberWithFloat:distance], @"distance", query, @"query", nil];
  NSData *postData = [[CJSONDataSerializer serializer] serializeDictionary:postJson];
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/checkin/nearby", MOOGLE_BASE_URL, API_VERSION];
  self.nearbyPlacesRequest = [RemoteRequest postRequestWithBaseURLString:baseURLString andParams:nil andPostData:postData isGzip:NO withDelegate:self];
  [[RemoteOperation sharedInstance] addRequestToQueue:self.nearbyPlacesRequest];
}

#pragma mark ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
  // This is on the main thread
  NSInteger statusCode = [request responseStatusCode];
  if(statusCode > 200) {
    UIAlertView *networkErrorAlert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:FM_NETWORK_ERROR delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try Again", nil];
    [networkErrorAlert show];
    [networkErrorAlert autorelease];
  } else {  
    self.responseArray = [[CJSONDeserializer deserializer] deserializeAsArray:[request responseData] error:nil];
    [self.tableView reloadData];
  }
  DLog(@"nearby facebook places request finished successfully");
}

- (void)requestFailed:(ASIHTTPRequest *)request {
  DLog(@"Request Failed with Error: %@", [request error]);
  UIAlertView *networkErrorAlert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:FM_NETWORK_ERROR delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try Again", nil];
  [networkErrorAlert show];
  [networkErrorAlert autorelease];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  PlaceViewController *pvc = [[PlaceViewController alloc] initWithNibName:@"PlaceViewController" bundle:nil];
  pvc.placeId = [[self.responseArray objectAtIndex:indexPath.row] objectForKey:@"id"];
  [self presentModalViewController:pvc animated:YES];
  [pvc release];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.numberOfLines = 100;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell_bg.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"table_cell_bg_selected.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:20]];
  }
  
  cell.textLabel.text = [[self.responseArray objectAtIndex:indexPath.row] objectForKey:@"name"];
  cell.detailTextLabel.text = [[self.responseArray objectAtIndex:indexPath.row] objectForKey:@"category"];
  
  return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}


- (void)dealloc {
  if(_nearbyPlacesRequest) {
    [_nearbyPlacesRequest clearDelegatesAndCancel];
    [_nearbyPlacesRequest release], _nearbyPlacesRequest = nil;
  }
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kLocationAcquired object:nil];
  
  RELEASE_SAFELY(_tableView);
  [super dealloc];
}


@end
