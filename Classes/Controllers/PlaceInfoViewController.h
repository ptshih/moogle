//
//  PlaceInfoViewController.h
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PlaceTabViewController.h"

@interface PlaceInfoViewController : PlaceTabViewController {
  IBOutlet UIView *_infoView;
  UIImage *_placeImage;
  UILabel *_placeNameLabel;
  UILabel *_placeAddressLabel;
  UILabel *_reviewsLabel;
  UIImageView *_starsImageView;
}
@property (nonatomic, retain) IBOutlet UILabel *placeNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *placeAddressLabel;
@property (nonatomic, retain) IBOutlet UILabel *reviewsLabel;
@property (nonatomic, retain) IBOutlet UIImageView *starsImageView;

- (void)loadPlaceInfo;
- (void)reloadPlaceInfo;

@end
