/*
 *  ImageCacheDelegate.h
 *  Prototype
 *
 *  Created by Peter Shih on 2/14/11.
 *  Copyright 2011 LinkedIn. All rights reserved.
 *
 */

@protocol ImageCacheDelegate <NSObject>
@required
- (void)imageDidLoad:(NSIndexPath *)indexPath;
@end
