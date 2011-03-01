//
//  WhoViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTableViewController.h"
#import "WhoFilterDelegate.h"

@interface WhoViewController : CardTableViewController {
  UINavigationBar *_navigationBar;
  NSMutableDictionary *_selectedDict;

  id <WhoFilterDelegate> _delegate;
}

@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) NSMutableDictionary *selectedDict;

@property (nonatomic, assign) id <WhoFilterDelegate> delegate;

- (void)dismiss;

@end
