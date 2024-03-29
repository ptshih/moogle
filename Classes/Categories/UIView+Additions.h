//
//  UIView+Additions.h
//  Friendmash
//
//  Created by Peter Shih on 11/12/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (Additions)

@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat top;
@property(nonatomic,readonly) CGFloat right;
@property(nonatomic,readonly) CGFloat bottom;

@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@property(nonatomic,readonly) CGFloat screenX;
@property(nonatomic,readonly) CGFloat screenY;

@property(nonatomic,readonly) CGFloat screenViewX;
@property(nonatomic,readonly) CGFloat screenViewY;

- (UIScrollView*)findFirstScrollView;

- (UIView*)firstViewOfClass:(Class)cls;

- (UIView*)firstParentOfClass:(Class)cls;

- (UIView*)findChildWithDescendant:(UIView*)descendant;

/**
 *
 */
- (void)removeSubviews;

@end