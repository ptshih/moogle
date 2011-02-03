//
//  LauncherViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LauncherViewController : UIViewController {
  UITabBarController *_tabBarController;
}

@property (nonatomic, retain) UITabBarController *tabBarController;

@end
