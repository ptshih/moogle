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
- (void)friendPickedWithString:(NSString *)friends;

@end
