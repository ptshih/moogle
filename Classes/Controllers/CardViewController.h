//
//  CardViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CardViewController : UIViewController {
  BOOL _isFiltering;
}

- (void)showPlaceWithId:(NSNumber *)placeId;
- (void)reloadCardController;

@end
