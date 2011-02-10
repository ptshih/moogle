//
//  CheckinsViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearbyPlacesDelegate.h"

@class ASIHTTPRequest;
@class NearbyPlacesViewController;

@interface CheckinsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NearbyPlacesDelegate> {
  IBOutlet UITableView *_tableView;
  IBOutlet UIView *_filterView;
  
  NearbyPlacesViewController *_nearbyPlacesViewController;
  
  ASIHTTPRequest *_checkinsRequest;
  NSArray *_responseArray;
  
  UIAlertView *_logoutAlert;
  
  BOOL _isFiltering;
  BOOL _isShowingNearbyPlaces;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *filterView;

@property (nonatomic, retain) NearbyPlacesViewController *nearbyPlacesViewController;

@property (nonatomic, retain) ASIHTTPRequest *checkinsRequest;
@property (nonatomic, retain) NSArray *responseArray;

- (void)getCheckins;

@end
