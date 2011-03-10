//
//  WhoViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTableViewController.h"
#import "FriendPickerDelegate.h"

@class FriendPickerViewController;

@interface WhoViewController : CardTableViewController <FriendPickerDelegate> {  
  NSMutableArray *_sortedFriends;
  NSMutableArray *_sortedGroups;
  
  FriendPickerViewController *_fpvc;

  id <FriendPickerDelegate> _delegate;
}

@property (nonatomic, assign) id <FriendPickerDelegate> delegate;

- (void)dismiss;

@end
