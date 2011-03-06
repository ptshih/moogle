//
//  FriendPickerViewController.h
//  Moogle
//
//  Created by Peter Shih on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTableViewController.h"
#import "FriendPickerDelegate.h"

@interface FriendPickerViewController : CardTableViewController {
  NSMutableDictionary *_selectedDict;
  NSMutableArray *_sortedFriends;
  
  id <FriendPickerDelegate> _delegate;
}

@property (nonatomic, assign) id <FriendPickerDelegate> delegate;
@property (nonatomic, retain) NSMutableDictionary *selectedDict;

- (void)dismiss;

@end
