//
//  MoogleImageCell.m
//  Moogle
//
//  Created by Peter Shih on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MoogleImageCell.h"

@implementation MoogleImageCell

@synthesize smaImageView = _smaImageView;
@synthesize imageLoadingIndicator = _imageLoadingIndicator;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _smaImageView = [[SMAImageView alloc] init];
    _imageLoadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_imageLoadingIndicator startAnimating];
    [self.contentView addSubview:_imageLoadingIndicator];
    [self.contentView addSubview:_smaImageView];
    
    // Override default text labels
    self.textLabel.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  [self.smaImageView unloadImage];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  if ([[self class] cellType] == MoogleCellTypePlain) {
    self.smaImageView.width = IMAGE_WIDTH_PLAIN;
    self.smaImageView.height = IMAGE_HEIGHT_PLAIN;
  } else {
    self.smaImageView.width = IMAGE_WIDTH_GROUPED;
    self.smaImageView.height = IMAGE_HEIGHT_GROUPED;
  }
  self.smaImageView.top = SPACING_Y;
  self.smaImageView.left = SPACING_X;
  self.smaImageView.layer.masksToBounds = YES;
  self.smaImageView.layer.cornerRadius = 4.0;
  
  _imageLoadingIndicator.frame = CGRectMake(15, 15, 20, 20);

  self.textLabel.left = self.smaImageView.right + SPACING_X;
  
}

+ (CGFloat)rowHeight {
  // Subclasses should override
  return 60.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)dealloc {
  RELEASE_SAFELY(_smaImageView);
  RELEASE_SAFELY(_imageLoadingIndicator);
  [super dealloc];
}

@end
