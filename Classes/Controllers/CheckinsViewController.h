//
//  CheckinsViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASIHTTPRequest;

@interface CheckinsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
  IBOutlet UITableView *_meTableView;
  
  ASIHTTPRequest *_checkinsRequest;
  NSArray *_responseArray;
}

@property (nonatomic, retain) UITableView *meTableView;

@property (nonatomic, retain) ASIHTTPRequest *checkinsRequest;
@property (nonatomic, retain) NSArray *responseArray;

@end
