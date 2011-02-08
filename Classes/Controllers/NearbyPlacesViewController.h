//
//  NearbyPlacesViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASIHTTPRequest;

@interface NearbyPlacesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
  IBOutlet UITableView *_tableView;
  
  ASIHTTPRequest *_nearbyPlacesRequest;
  NSArray *_responseArray;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) ASIHTTPRequest *nearbyPlacesRequest;
@property (nonatomic, retain) NSArray *responseArray;

@end
