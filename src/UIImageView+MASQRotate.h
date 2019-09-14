//
// Created by Alex Hajdu on 5/27/13.
// Copyright (c) 2013 Mr.Fox and friends. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface UIImageView (MASQRotate)
- (void)rotateImageView;
- (void)rotate360WithDuration:(CGFloat)duration repeatCount:(float)repeatCount;
- (void)pauseAnimations;
- (void)resumeAnimations;
- (void)stopAllAnimations;
@end
