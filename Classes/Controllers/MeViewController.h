//
//  MeViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTableViewController.h"
#import "MoogleDataCenterDelegate.h"

@class ASIHTTPRequest;
@class MeDataCenter;

@interface MeViewController : CardTableViewController <MoogleDataCenterDelegate> {
  MeDataCenter *_dataCenter;
  UIAlertView *_logoutAlert;
  
  ASIHTTPRequest *_kupoRequest;
}

@property (nonatomic, retain) MeDataCenter *dataCenter;
@property (nonatomic, retain) ASIHTTPRequest *kupoRequest;

- (void)getKupos;

@end
