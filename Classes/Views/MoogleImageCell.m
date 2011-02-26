//
//  MoogleImageCell.m
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MoogleImageCell.h"

@implementation MoogleImageCell

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
  _imageLoadingIndicator.frame = CGRectMake(7 + 15, 20, 20, 20);
}

+ (CGFloat)rowHeight {
  // Subclasses should override
  return 60.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)dealloc {
  RELEASE_SAFELY(_imageLoadingIndicator);
  [super dealloc];
}

@end
