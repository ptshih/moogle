//
//  MeFriendsViewController.h
//  Moogle
//
//  Created by Peter Shih on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTableViewController.h"

@interface MeFriendsViewController : CardTableViewController {
  NSArray *_rawFriendsArray;
}

@property (nonatomic, retain) NSArray *rawFriendsArray;

- (void)loadFriends;

@end
