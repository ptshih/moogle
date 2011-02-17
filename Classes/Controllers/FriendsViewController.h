//
//  FriendsViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTableViewController.h"

@class ASIHTTPRequest;

@interface FriendsViewController : CardTableViewController {
  ASIHTTPRequest *_checkinsRequest;
}

@property (nonatomic, retain) ASIHTTPRequest *checkinsRequest;

- (void)getCheckins;

@end
