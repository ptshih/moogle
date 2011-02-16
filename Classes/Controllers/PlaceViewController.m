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

@interface PlaceViewController (Private)

- (void)postCheckin;

@end

@implementation PlaceViewController

@synthesize checkinButton = _checkinButton;
@synthesize placeId = _placeId;
@synthesize message = _message;
@synthesize tagsArray = _tagsArray;
@synthesize checkinHereRequest = _checkinHereRequest;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for loadView.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

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
  self.checkinHereRequest = [RemoteRequest postFacebookCheckinRequestWithParams:postDict withDelegate:self];
  [[RemoteOperation sharedInstance] addRequestToQueue:self.checkinHereRequest];  
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
    DLog(@"response: %@", [request responseString]);
  }
  DLog(@"checkins request finished successfully");
}

- (void)requestFailed:(ASIHTTPRequest *)request {
  DLog(@"Request Failed with Error: %@", [request error]);
  UIAlertView *networkErrorAlert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:FM_NETWORK_ERROR delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try Again", nil];
  [networkErrorAlert show];
  [networkErrorAlert autorelease];
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
  if (_checkinHereRequest) {
    [_checkinHereRequest clearDelegatesAndCancel];
    [_checkinHereRequest release], _checkinHereRequest = nil;
  }
  
  RELEASE_SAFELY (_placeId);
  RELEASE_SAFELY (_message);
  RELEASE_SAFELY (_tagsArray);
  RELEASE_SAFELY (_checkinButton);
  [super dealloc];
}


@end
