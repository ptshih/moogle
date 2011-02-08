//
//  NearbyPlacesViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NearbyPlacesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
  IBOutlet UITableView *_tableView;
  
  NSArray *_responseArray;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *responseArray;

@end
