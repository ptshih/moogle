//
//  MoogleCell.m
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MoogleCell.h"


@implementation MoogleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _imageLoadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_imageLoadingIndicator startAnimating];
    [self.contentView addSubview:_imageLoadingIndicator];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _imageLoadingIndicator.frame = CGRectMake(SPACING_X + 15, 20, 20, 20);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)dealloc {
  RELEASE_SAFELY(_imageLoadingIndicator);
  [super dealloc];
}

@end
