//
//  CardModalViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CardModalViewController : UIViewController {
  UINavigationBar *_navigationBar;
  NSString *_dismissButtonTitle;
}

@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) NSString *dismissButtonTitle;

- (void)dismiss;

@end
