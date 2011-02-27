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
  id <WhoFilterDelegate> _delegate;
}

@property (nonatomic, assign) id <WhoFilterDelegate> delegate;

@end
