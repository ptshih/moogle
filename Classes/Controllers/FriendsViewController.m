    //
//  FriendsViewController.m
//  Moogle
//
//  Created by Peter Shih on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FriendsViewController.h"
#import "Constants.h"

@implementation FriendsViewController

- (id)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)loadView {
  [super loadView];

  self.navigationController.navigationBar.tintColor = FB_COLOR_DARK_BLUE;
  self.title = @"Moogle Friends";
}


- (void)dealloc {
  [super dealloc];
}


@end
