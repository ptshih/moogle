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
#import "SMAURLCache.h"
#import "SMAImageView.h"

@interface CardViewController : UIViewController <CardStateMachine, UINavigationControllerDelegate> {
  IBOutlet UIView *_emptyView;
  IBOutlet UILabel *_emptyLabel;
  IBOutlet UIView *_loadingView;
  IBOutlet UILabel *_loadingLabel;
  IBOutlet UIActivityIndicatorView *_loadingSpinner;
}

@property (nonatomic, retain) UIView *emptyView;
@property (nonatomic, retain) UILabel *emptyLabel;
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UILabel *loadingLabel;
@property (nonatomic, retain) UIActivityIndicatorView *loadingSpinner;

- (void)clearCachedData;
- (void)unloadCardController;
- (void)reloadCardController;
- (void)dataSourceDidLoad;
- (void)setupLoadingAndEmptyViews;

@end
