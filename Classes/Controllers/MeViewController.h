//
//  MeViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTableViewController.h"

@class ASIHTTPRequest;

@interface MeViewController : CardTableViewController {
  ASIHTTPRequest *_checkinsRequest;
  
  UIAlertView *_logoutAlert;
}

@property (nonatomic, retain) ASIHTTPRequest *checkinsRequest;

- (void)getCheckins;

@end
