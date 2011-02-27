//
//  PlaceFeedCell.h
//  Moogle
//
//  Created by Peter Shih on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoogleImageCell.h"

@interface PlaceFeedCell : MoogleImageCell {
  UILabel *_nameLabel;
  UILabel *_messageLabel;
  UILabel *_timestampLabel;
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *messageLabel;
@property (nonatomic, retain) UILabel *timestampLabel;

+ (void)fillCell:(PlaceFeedCell *)cell withDictionary:(NSDictionary *)dictionary withImage:(UIImage *)image;

@end
