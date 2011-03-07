//
//  MeViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CardTableViewController.h"
#import "MoogleDataCenterDelegate.h"

@class MeDataCenter;

@interface MeViewController : CardTableViewController <MoogleDataCenterDelegate> {
  // UI
  IBOutlet UILabel *_nameLabel;
  IBOutlet UILabel *_lastPlaceLabel;
  IBOutlet UIImageView *_profilePicture;
  
  IBOutlet UIView *_checkinsView;
  IBOutlet UIView *_placesView;
  IBOutlet UIView *_friendsView;
  IBOutlet UILabel *_checkinsLabel;
  IBOutlet UILabel *_placesLabel;
  IBOutlet UILabel *_friendsLabel;
  
  MeDataCenter *_dataCenter;
  UIAlertView *_logoutAlert;
  
  ASIHTTPRequest *_meRequest;
  
  NSDictionary *_lastCheckin;
  NSDictionary *_userStats;
}

@property (nonatomic, retain) MeDataCenter *dataCenter;
@property (nonatomic, retain) ASIHTTPRequest *meRequest;

@property (nonatomic, retain) NSDictionary *lastCheckin;
@property (nonatomic, retain) NSDictionary *userStats;

- (void)getMe;

@end
