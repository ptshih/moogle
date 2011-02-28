//
//  LoginViewController.h
//  Friendmash
//
//  Created by Peter Shih on 11/11/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FacebookLoginDelegate <NSObject>
@optional
- (void)fbDidLoginWithToken:(NSString *)token andExpiration:(NSDate *)expiration;
- (void)fbDidNotLoginWithError:(NSError *)error userDidCancel:(BOOL)userDidCancel;
@end

@interface LoginViewController : UIViewController {
  IBOutlet UIWebView *_fbWebView;
  IBOutlet UIView *_loginView;
  IBOutlet UIView *_splashView;
  IBOutlet UILabel *_splashLabel;
  NSURL *_authorizeURL;
  id <FacebookLoginDelegate> _delegate;
}

@property (nonatomic, retain) UIWebView *fbWebView;
@property (nonatomic, retain) UIView *loginView;
@property (nonatomic, retain) UIView *splashView;
@property (nonatomic, retain) UILabel *splashLabel;

@property (nonatomic, retain) NSURL *authorizeURL;
@property (nonatomic, assign) id <FacebookLoginDelegate> delegate;

- (void)resetLoginState;
- (IBAction)ssoLogin;
- (IBAction)normalLogin;
- (IBAction)terms;
- (IBAction)privacy;
- (void)authorizeWithFBAppAuth:(BOOL)tryFBAppAuth safariAuth:(BOOL)trySafariAuth;;

@end
