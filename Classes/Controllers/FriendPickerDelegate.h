//
//  FriendPickerDelegate.h
//  Moogle
//
//  Created by Peter Shih on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FriendPickerDelegate <NSObject>
@optional
- (void)friendPickedWithFriendIds:(NSString *)friendIds;
- (void)friendPickedWithFriendNames:(NSString *)friendNames;

@end
