//
//  NearbyPlacesViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardViewController.h"
#import "NearbyPlacesDelegate.h"

@class ASIHTTPRequest;

@interface NearbyPlacesViewController : CardViewController <UITableViewDelegate, UITableViewDataSource> {
  IBOutlet UITableView *_tableView;
  
  ASIHTTPRequest *_nearbyPlacesRequest;
  NSArray *_responseArray;
  
  id <NearbyPlacesDelegate> delegate;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) ASIHTTPRequest *nearbyPlacesRequest;
@property (nonatomic, retain) NSArray *responseArray;

@property (nonatomic, assign) id <NearbyPlacesDelegate> delegate;

- (void)getNearbyPlaces;

@end
