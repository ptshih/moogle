//
//  MoogleAppDelegate.m
//  Moogle
//
//  Created by Peter Shih on 1/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MoogleAppDelegate.h"
#import "LauncherViewController.h"
#import "Constants.h"
#import "ASIHTTPRequest.h"
#import "RemoteRequest.h"
#import "RemoteOperation.h"
#import "CJSONDeserializer.h"
#import "LocationManager.h"

@interface MoogleAppDelegate (Private)

// Authentication
- (BOOL)isAuthenticatedWithFacebook;
- (void)restoreFacebookCredentials;
- (void)loginFacebook;
- (void)fbDidLogin;
- (void)fbDidLogout;

// Session
- (void)startRegister;
- (void)startSession;
- (void)sessionReady;

// Requests
- (void)postStartSessionRequest;

// Used for FB SSO
- (NSDictionary*)parseURLParams:(NSString *)query;

// User Defaults
+ (void)setupDefaults;

@end

@implementation MoogleAppDelegate

@synthesize window = _window;
@synthesize loginViewController =_loginViewController;
@synthesize launcherViewController = _launcherViewController;

// Requests
@synthesize registerRequest = _registerRequest;
@synthesize sessionRequest = _sessionRequest;

// Reachability
@synthesize hostReach = _hostReach;
@synthesize netStatus = _netStatus;
@synthesize reachabilityAlertView = _reachabilityAlertView;

// Session
@synthesize sessionKey = _sessionKey;

// Facebook
@synthesize fbAccessToken = _fbAccessToken;

// Config
@synthesize isLoggedIn = _isLoggedIn;
@synthesize isSessionReady = _isSessionReady;

// Location
@synthesize locationManager = _locationManager;

#pragma mark -
#pragma mark Application lifecycle

+ (void)initialize {
  [self setupDefaults];
}

+ (void)setupDefaults {
  if ([self class] == [MoogleAppDelegate class]) {
    NSString *initialDefaultsPath = [[NSBundle mainBundle] pathForResource:@"InitialDefaults" ofType:@"plist"];
    assert(initialDefaultsPath != nil);
    
    NSDictionary *initialDefaults = [NSDictionary dictionaryWithContentsOfFile:initialDefaultsPath];
    assert(initialDefaults != nil);
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:initialDefaults];
  }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Setup Default Settings
  _isLoggedIn = NO;
  _isShowingLogin = NO;
  _isSessionReady = NO;
  
  // Prepare View Controllers
  _launcherViewController = [[LauncherViewController alloc] initWithNibName:@"LauncherViewController" bundle:nil];
  _loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
  self.loginViewController.delegate = self;
  
  // Reachability
  _reachabilityAlertView = [[UIAlertView alloc] initWithTitle:@"No Network Connection" message:@"An active network connection is required to use Moogle." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
  
	_hostReach = [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
  _netStatus = 0; // default netstatus to 0
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
  [self.hostReach startNotifier];
  
  // Location
  _locationManager = [[LocationManager alloc] init];
  
  // Finish Launching
  [self.window addSubview:self.launcherViewController.view];
  [self.window makeKeyAndVisible];
  
  return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  if (!_isShowingLogin) {
    // Check Authentication
    _isLoggedIn = [self isAuthenticatedWithFacebook];
    
    _isSessionReady = NO;
    
    if (_isLoggedIn) {
      [self restoreFacebookCredentials];
    } else {
      [self loginFacebook];
    }
  }
  
  [self.locationManager startStandardUpdates];
}

- (void)applicationWillResignActive:(UIApplication *)application {
  [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"lastExitDate"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [[RemoteOperation sharedInstance] cancelAllRequests];
  [self.locationManager stopStandardUpdates];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"lastExitDate"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [[RemoteOperation sharedInstance] cancelAllRequests];
  [self.locationManager stopStandardUpdates];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
  [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"lastExitDate"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [[RemoteOperation sharedInstance] cancelAllRequests];
  [self.locationManager stopStandardUpdates];
}

#pragma mark -
#pragma mark Facebook Login
- (BOOL)isAuthenticatedWithFacebook {
  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedIn"]) {
    return YES;
  } else {
    return NO;
  }
}

- (void)restoreFacebookCredentials {
  self.fbAccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"fbAccessToken"];
  
  // Only start a new session if it has been more than 10 minutes
  NSTimeInterval timeDiff = [[NSDate date] timeIntervalSinceDate:[[NSUserDefaults standardUserDefaults] valueForKey:@"lastExitDate"]];
  NSInteger timeDiffInt = floor(timeDiff);
  DLog(@"Attempting to start a new session with lastExitDiff: %d", timeDiffInt);
  if (timeDiffInt > 600) {
    [self startSession];
  } else {
    [self.launcherViewController reloadVisibleCard];
  }
}

- (void)loginFacebook {
  if(_isShowingLogin) {
    [self.loginViewController resetLoginState];
  } else {
      _isShowingLogin = YES;
    [self.launcherViewController presentModalViewController:self.loginViewController animated:YES];
  }
}

- (void)dismissLoginView:(BOOL)animated {
  [self.loginViewController dismissModalViewControllerAnimated:animated];
  _isShowingLogin = NO;
}

- (void)logoutFacebook {
#ifdef FB_EXPIRE_TOKEN
  // Send the expire session request to FB to force logout
  NSString *token = [APP_DELEGATE.fbAccessToken stringWithPercentEscape];
  NSString *params = [NSString stringWithFormat:@"access_token=%@",token];
  NSString *baseURLString = @"https://api.facebook.com/method/auth.expireSession";
  NSString *logoutURLString = [NSString stringWithFormat:@"%@?%@", baseURLString, params];
  NSURL *logoutURL = [NSURL URLWithString:logoutURLString];
  NSMutableURLRequest *logoutRequest = [NSMutableURLRequest requestWithURL:logoutURL];
  [logoutRequest setHTTPMethod:@"GET"];
  NSHTTPURLResponse *logoutResponse;
  [NSURLConnection sendSynchronousRequest:logoutRequest returningResponse:&logoutResponse error:nil];
  DLog(@"logging out with response code: %d",[logoutResponse statusCode]);
#endif
  
  // NOTE
  // It might be a good idea to send a request to FM servers to expire/delete this access_token
  
  // Delete facebook cookies
  NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  NSArray* facebookCookies = [cookies cookiesForURL:[NSURL URLWithString:@"http://login.facebook.com"]];
  
  for (NSHTTPCookie* cookie in facebookCookies) {
    [cookies deleteCookie:cookie];
  }
  [self fbDidLogout];
}

- (void)fbDidLogout {
  // Tell all cards to unload their cached data
  [self.launcherViewController clearAllCachedData];
  
  self.fbAccessToken = nil;
  self.sessionKey = nil;
  
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"friends"];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"groups"];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastExitDate"];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fbAccessToken"];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"facebookId"];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isLoggedIn"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [self loginFacebook];
}

#pragma mark FacebookLoginDelegate
- (void)fbDidLoginWithToken:(NSString *)token andExpiration:(NSDate *)expiration {
  DLog(@"Received OAuth access token: %@",token);
  
  // Set the facebook access token
  // ignore the expiration since we request non-expiring offline access
  self.fbAccessToken = token;
  [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"fbAccessToken"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  // Start register flow with moogle
  [self startRegister];
}

- (void)fbDidNotLoginWithError:(NSError *)error userDidCancel:(BOOL)userDidCancel {
  DLog(@"Login failed with error: %@, user did cancel: %d",error, userDidCancel);
  NSString *errorTitle;
  NSString *errorMessage;
  if(userDidCancel) {
    errorTitle = @"Permissions Error";
    errorMessage = @"Friendmash was unable to login to Facebook. Please try again.";
  } else {
    errorTitle = @"Login Error";
    errorMessage = @"Friendmash is having trouble logging in to Facebook. Please try again.";
  }
  
  _loginFailedAlert = [[UIAlertView alloc] initWithTitle:errorTitle message:errorMessage delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
  [_loginFailedAlert show];
  [_loginFailedAlert autorelease];
}

#pragma mark -
#pragma mark HTTP Requests
- (void)postRegisterRequest {
  DLog(@"starting register request to moogle");
  
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/moogle/register", MOOGLE_BASE_URL, API_VERSION];
  self.registerRequest = [RemoteRequest postRequestWithBaseURLString:baseURLString andParams:params isGzip:NO withDelegate:self];
  [[RemoteOperation sharedInstance] addRequestToQueue:self.registerRequest];
}

- (void)postStartSessionRequest {
  DLog(@"starting session request to moogle");
  
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  
  NSString *baseURLString = [NSString stringWithFormat:@"%@/%@/moogle/session", MOOGLE_BASE_URL, API_VERSION];
  self.sessionRequest = [RemoteRequest postRequestWithBaseURLString:baseURLString andParams:params isGzip:NO withDelegate:self];
  [[RemoteOperation sharedInstance] addRequestToQueue:self.sessionRequest];
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
  NSInteger statusCode = [request responseStatusCode];
  
  if ([request isEqual:self.registerRequest]) {
    // First time registering a new user
    DLog(@"register request finished");
    if(statusCode > 200) {
      _networkErrorAlert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:FM_NETWORK_ERROR delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
      [_networkErrorAlert show];
      [_networkErrorAlert autorelease];
    } else {
      // Moogle server will send user ID, name, and array of friend ids
      
      [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedIn"];
      [[NSUserDefaults standardUserDefaults] setObject:[[[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil] objectForKey:@"facebook_id"] forKey:@"facebookId"];
      [[NSUserDefaults standardUserDefaults] setObject:[[[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil] objectForKey:@"name"] forKey:@"facebookName"];
      [[NSUserDefaults standardUserDefaults] setObject:[[[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil] objectForKey:@"friends"] forKey:@"friends"];
      [[NSUserDefaults standardUserDefaults] synchronize];
      
      _isSessionReady = YES;
      [self sessionReady];
      
      // dismiss the login view
      [self dismissLoginView:YES];
    }
  } else if([request isEqual:self.sessionRequest]) {
    // Starting a new session
    DLog(@"session request finished");
    if(statusCode > 200) {
      _networkErrorAlert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:FM_NETWORK_ERROR delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
      [_networkErrorAlert show];
      [_networkErrorAlert autorelease];
    } else {
      // Success
      _isSessionReady = YES;
      [self sessionReady];
    }
  }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
  DLog(@"Request Failed with Error: %@", [request error]);
}

- (void)sessionReady {
  [self.launcherViewController reloadVisibleCard];
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if([alertView isEqual:_networkErrorAlert]) {
    // Session or Register request failed
    // Make sure to reset state and try again
    // NOTE
    
    
    
  } else if([alertView isEqual:_loginFailedAlert]) {
    [self loginFacebook];
  }
}

#pragma mark -
#pragma mark Facebook Single Sign On
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
  // If the URL's structure doesn't match the structure used for Facebook authorization, abort.
  if (![[url absoluteString] hasPrefix:[NSString stringWithFormat:@"fb%@://authorize", FB_APP_ID]]) {
    return NO;
  }
  
  NSString *query = [url fragment];
  
  // Version 3.2.3 of the Facebook app encodes the parameters in the query but
  // version 3.3 and above encode the parameters in the fragment. To support
  // both versions of the Facebook app, we try to parse the query if
  // the fragment is missing.
  if (!query) {
    query = [url query];
  }
  
  NSDictionary *params = [self parseURLParams:query];
  NSString *accessToken = [params valueForKey:@"access_token"];
  
  // If the URL doesn't contain the access token, an error has occurred.
  if (!accessToken) {
    NSString *errorReason = [params valueForKey:@"error"];
    
    // If the error response indicates that we should try again using Safari, open
    // the authorization dialog in Safari.
    if (errorReason && [errorReason isEqualToString:@"service_disabled_use_browser"]) {
      [self.loginViewController authorizeWithFBAppAuth:NO safariAuth:YES];
      return YES;
    }
    
    // If the error response indicates that we should try the authorization flow
    // in an inline dialog, do that.
    if (errorReason && [errorReason isEqualToString:@"service_disabled"]) {
      [self.loginViewController authorizeWithFBAppAuth:NO safariAuth:NO];
      return YES;
    }
    
    // The facebook app may return an error_code parameter in case it
    // encounters a UIWebViewDelegate error. This should not be treated
    // as a cancel.
    NSString *errorCode = [params valueForKey:@"error_code"];    
    BOOL userDidCancel =
    !errorCode && (!errorReason || [errorReason isEqualToString:@"access_denied"]);
    [self fbDidNotLoginWithError:nil userDidCancel:userDidCancel];
    return YES;
  }
  
  // We have an access token, so parse the expiration date.
  NSString *expTime = [params valueForKey:@"expires_in"];
  NSDate *expirationDate = [NSDate distantFuture];
  if (expTime != nil) {
    int expVal = [expTime intValue];
    if (expVal != 0) {
      expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
    }
  }
  
  //  [self fbDialogLogin:accessToken expirationDate:expirationDate];
  [self fbDidLoginWithToken:accessToken andExpiration:expirationDate];
  return YES;
}

- (NSDictionary*)parseURLParams:(NSString *)query {
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
		NSString *val =
    [[kv objectAtIndex:1]
     stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
		[params setObject:val forKey:[kv objectAtIndex:0]];
	}
  return params;
}

#pragma mark -
#pragma mark Reachability
//Called by Reachability whenever status changes.
- (void)reachabilityChanged:(NSNotification *)note {
	Reachability *curReach = [note object];
	self.netStatus = [curReach currentReachabilityStatus];
	
	if(curReach == self.hostReach) {
		if(self.netStatus > kNotReachable) {
      if(self.reachabilityAlertView && self.reachabilityAlertView.visible) {
        [self.reachabilityAlertView dismissWithClickedButtonIndex:0 animated:YES];
      }
		} else {
      [self.reachabilityAlertView show];
    }
	}
}

//- (void)didPresentAlertView:(UIAlertView *)alertView {
//  static BOOL busyAlertHasIndicator = NO;
//  if (alertView != self.reachabilityAlertView || busyAlertHasIndicator) return;
//  UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//  indicator.center = CGPointMake(self.reachabilityAlertView.bounds.size.width / 2, self.reachabilityAlertView.bounds.size.height - 45);
//  [indicator startAnimating];
//  [self.reachabilityAlertView addSubview:indicator];
//  [indicator release];
//  busyAlertHasIndicator = YES;
//}

#pragma mark Session
- (void)startSession {
  // This gets called on subsequent app launches
  // Set Session Key
  NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];
  NSInteger currentTimestampInteger = floor(currentTimestamp);
  self.sessionKey = [NSString stringWithFormat:@"%d", currentTimestampInteger];
  
  [self postStartSessionRequest];
}

- (void)startRegister {
  // This gets called] if it is the first time logging in
  // Set Session Key
  NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];
  NSInteger currentTimestampInteger = floor(currentTimestamp);
  self.sessionKey = [NSString stringWithFormat:@"%d", currentTimestampInteger];
  
  [self postRegisterRequest];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}


- (void)dealloc {
  if (_registerRequest) {
    [_registerRequest clearDelegatesAndCancel];
    [_registerRequest release], _registerRequest = nil;
  }
  
  if (_sessionRequest) {
    [_sessionRequest clearDelegatesAndCancel];
    [_sessionRequest release], _sessionRequest = nil;
  }
  
  RELEASE_SAFELY(_loginViewController);
  RELEASE_SAFELY(_launcherViewController);
  RELEASE_SAFELY(_hostReach);
  RELEASE_SAFELY(_reachabilityAlertView);
  RELEASE_SAFELY(_sessionKey);
  RELEASE_SAFELY(_fbAccessToken);
  RELEASE_SAFELY(_locationManager);
  RELEASE_SAFELY(_window);
  [super dealloc];
}

@end
