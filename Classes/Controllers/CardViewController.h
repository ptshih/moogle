//
//  CardViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CardViewController : UIViewController {
  UIView *_filterView;
  
  BOOL _isFiltering;
}

@property (nonatomic, retain) UIView *filterView;

- (void)clearCachedData;
- (void)unloadCardController;
- (void)reloadCardController;

- (void)showPlaceWithId:(NSNumber *)placeId;
- (void)reloadCardController;

@end
