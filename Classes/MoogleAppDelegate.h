//
//  MoogleAppDelegate.h
//  Moogle
//
//  Created by Peter Shih on 1/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "LoginViewController.h"

@class ASIHTTPRequest;
@class LocationManager;
@class LauncherViewController;

@interface MoogleAppDelegate : NSObject <UIApplicationDelegate, FacebookLoginDelegate> {
  UIWindow *_window;
  LoginViewController *_loginViewController;
  LauncherViewController *_launcherViewController;
  
  // Requests
  ASIHTTPRequest *_sessionRequest;
  
  // Reachability
  Reachability *_hostReach;
	NetworkStatus _netStatus;
  UIAlertView *_reachabilityAlertView;
  
  // Session
  NSString *_sessionKey;
  
  // Facebook
  NSString *_fbAccessToken;
  NSString *_fbUserId;
//  NSString *_fbUserName;
//  NSString *_fbUserFirstName;
//  NSString *_fbUserLastName;
  
  // AlertViews
  UIAlertView *_networkErrorAlert;
  UIAlertView *_loginFailedAlert;
  
  BOOL _isLoggedIn;
  BOOL _isShowingLogin;
  BOOL _isSessionReady;
  
  LocationManager *_locationManager;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) LoginViewController *loginViewController;
@property (nonatomic, retain) LauncherViewController *launcherViewController;

// Requests
@property (nonatomic, retain) ASIHTTPRequest *sessionRequest;

// Reachability
@property (nonatomic, retain) Reachability *hostReach;
@property (nonatomic, assign) NetworkStatus netStatus;
@property (nonatomic, retain) UIAlertView *reachabilityAlertView;

// Session
@property (nonatomic, retain) NSString *sessionKey;

// Facebook
@property (nonatomic, retain) NSString *fbAccessToken;
@property (nonatomic, retain) NSString *fbUserId;

// Config
@property (nonatomic, assign, readonly) BOOL isLoggedIn;
@property (nonatomic, assign, readonly) BOOL isSessionReady;

// Location
@property (nonatomic, retain) LocationManager *locationManager;

// Logout from Facebook
// This is called from MeViewController also
- (void)logoutFacebook;;

@end

