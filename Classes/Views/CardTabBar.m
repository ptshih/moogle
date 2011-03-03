//
//  CardTabBar.m
//  Moogle
//
//  Created by Peter Shih on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CardTabBar.h"

static UIImage *_checkinImage = nil;

@implementation CardTabBar

+ (void)initialize {
  _checkinImage = [[UIImage imageNamed:@"tab_checkin.png"] retain];
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
  }
  return self;
}

- (void)awakeFromNib {
  UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake(130.0, 3.0, _checkinImage.size.width, _checkinImage.size.height);
  [button setBackgroundImage:_checkinImage forState:UIControlStateNormal];
  
  [self addSubview:button];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
  [super dealloc];
}

@end
