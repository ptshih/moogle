//
//  PlaceViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceViewController.h"
#import "Constants.h"

#import "ASIHTTPRequest.h"
#import "RemoteRequest.h"
#import "RemoteOperation.h"

#import "LocationManager.h"

#import "PlacesDataCenter.h"

@interface PlaceViewController (Private)

- (void)postCheckin;

@end

@implementation PlaceViewController

@synthesize placeId = _placeId;
@synthesize message = _message;
@synthesize tagsArray = _tagsArray;
@synthesize checkinHereRequest = _checkinHereRequest;
@synthesize placeRequest = _placeRequest;
@synthesize placesDataCenter = _placesDataCenter;

- (id)init {
  self = [super init];
  if (self) {
    _placesDataCenter = [[PlacesDataCenter alloc] init];
    _placesDataCenter.delegate = self;
  }
  return self;
}

- (void)loadView {
  [super loadView];
}
// Called when this card controller leaves active view
// Subclasses should override this method
- (void)unloadCardController {
  DLog(@"Called by class: %@", [self class]);
}

// Called when this card controller comes into active view
// Subclasses should override this method
- (void)reloadCardController {
  DLog(@"Called by class: %@", [self class]);
}

- (IBAction)checkinHere {
  [self postCheckin];
}

- (void)postCheckin {
  CGFloat lat = [APP_DELEGATE.locationManager latitude];
  CGFloat lng = [APP_DELEGATE.locationManager longitude];
  
  NSString *coordinates = [NSString stringWithFormat:@"{\"latitude\":\"%f\", \"longitude\":\"%f\"}", lat, lng];
  
  NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
  [postDict setObject:self.placeId forKey:@"place"];
  [postDict setObject:coordinates forKey:@"coordinates"];
  if (self.message) [postDict setObject:self.message forKey:@"message"];
  if (self.tagsArray) {
    NSString *tags = [self.tagsArray componentsJoinedByString:@","];
    [postDict setObject:tags forKey:@"tags"];
  }
  
  DLog(@"posting checkin to facebook with params: %@", postDict);
  self.checkinHereRequest = [RemoteRequest postFacebookCheckinRequestWithParams:postDict withDelegate:self.placesDataCenter];
  self.placesDataCenter.checkinHereRequest = self.checkinHereRequest;
  [[RemoteOperation sharedInstance] addRequestToQueue:self.checkinHereRequest];
}

- (void)getPlace {
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/place/%@", MOOGLE_BASE_URL, API_VERSION, self.placeId];
  
  self.placeRequest = [RemoteRequest getRequestWithBaseURLString:baseURLString andParams:params withDelegate:self.placesDataCenter];
  [[RemoteOperation sharedInstance] addRequestToQueue:self.placeRequest];
}

- (void)dealloc {
  if (_checkinHereRequest) {
    [_checkinHereRequest clearDelegatesAndCancel];
    [_checkinHereRequest release], _checkinHereRequest = nil;
  }
  
  if (_placeRequest) {
    [_placeRequest clearDelegatesAndCancel];
    [_placeRequest release], _placeRequest = nil;
  }
  
  RELEASE_SAFELY (_placesDataCenter);
  
  RELEASE_SAFELY (_placeId);
  RELEASE_SAFELY (_message);
  RELEASE_SAFELY (_tagsArray);
  [super dealloc];
}


@end
