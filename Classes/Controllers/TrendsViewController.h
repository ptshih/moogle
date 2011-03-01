//
//  TrendsViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTableViewController.h"
#import "MoogleDataCenterDelegate.h"

@class TrendsDataCenter;

@interface TrendsViewController : CardTableViewController <MoogleDataCenterDelegate> {
  TrendsDataCenter *_dataCenter;
  
  ASIHTTPRequest *_trendsRequest;
}

@property (nonatomic, retain) TrendsDataCenter *dataCenter;
@property (nonatomic, retain) ASIHTTPRequest *trendsRequest;

- (void)getTrends;

@end
