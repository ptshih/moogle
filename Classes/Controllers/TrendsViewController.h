//
//  TrendsViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardViewController.h"

@class ASIHTTPRequest;

@interface TrendsViewController : CardViewController {
  IBOutlet UITableView *_tableView;
  IBOutlet UIView *_filterView;
  
  ASIHTTPRequest *_trendsRequest;
  NSArray *_responseArray;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *filterView;

@property (nonatomic, retain) ASIHTTPRequest *trendsRequest;
@property (nonatomic, retain) NSArray *responseArray;

@end
