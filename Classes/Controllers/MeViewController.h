//
//  MeViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardViewController.h"

@class ASIHTTPRequest;

@interface MeViewController : CardViewController {
  UIAlertView *_logoutAlert;
}

@end
