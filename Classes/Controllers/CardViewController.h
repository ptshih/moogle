//
//  CardViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "CardStateMachine.h"
#import "UINavigationBar+Custom.h"
#import "ASIHTTPRequest.h"
#import "RemoteRequest.h"
#import "RemoteOperation.h"

@interface CardViewController : UIViewController <CardStateMachine, UINavigationControllerDelegate> {
  IBOutlet UIView *_emptyView;
  IBOutlet UIView *_loadingView;
}

@property (nonatomic, retain) UIView *emptyView;
@property (nonatomic, retain) UIView *loadingView;

- (void)clearCachedData;
- (void)unloadCardController;
- (void)reloadCardController;
- (void)dataSourceDidLoad;

@end
