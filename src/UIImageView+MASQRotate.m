#import "UIImageView+MASQRotate.h"

@interface CABasicAnimation (Private)
// -(void)setRemovedOnCompletion:(BOOL)arg1;
@end

@implementation UIImageView (MASQRotate)

- (void)__debug_rotateImageView
{
    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self setTransform:CGAffineTransformRotate(self.transform, M_PI_2)];
    }completion:^(BOOL finished){
        if (finished) {
            [self __debug_rotateImageView];
        }
    }];
}

-(void)invokeHack {
  SEL sel = @selector(__debug_rotateImageView);
  UIImageView * obj = self;

  NSMethodSignature *methodSignature = [obj methodSignatureForSelector:sel];
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
  [invocation setSelector:sel];
  [invocation setTarget:obj];
  [invocation retainArguments];
}

#define SBLog(x) if ([NSBundle.mainBundle.bundleIdentifier isEqualToString:@"com.apple.springboard"]) HBLogDebug(x)

- (void)__debug_rotate360WithDuration:(CGFloat)duration repeatCount:(float)repeatCount
{
  SBLog(@"rotateDebug is here");
	CABasicAnimation *fullRotation;
	fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	fullRotation.fromValue = [NSNumber numberWithFloat:0];
	fullRotation.toValue = [NSNumber numberWithFloat:((360 * M_PI) / 180)];
	fullRotation.duration = duration;
  // fullRotation.removedOnCompletion = false; makes the thing not so good

	if (repeatCount == 0)
		fullRotation.repeatCount = MAXFLOAT;
	else
		fullRotation.repeatCount = repeatCount;

  // HBLogDebug(@"rotate 360 about to commit");
  if ([NSBundle.mainBundle.bundleIdentifier isEqualToString:@"com.apple.springboard"])
  {
    [self __debug_rotateImageView];
    // [self.layer addAnimation:fullRotation forKey:@"360"];
  }
  else
  {
  // [CATransaction begin];
// [self.artworkImageView.layer addAnimation:fullRotation forKey:@"360"];
	[self.layer addAnimation:fullRotation forKey:@"360"];

  // SBLog(@"animation should be commit next");
  // [CATransaction commit];

  // SBLog(@"commit done?");
  }
}

- (void)__debug_stopAllAnimations
{

	[self.layer removeAllAnimations];
};

- (void)__debug_pauseAnimations
{
	[self __debug_pauseLayer:self.layer];
}

- (void)__debug_resumeAnimations
{
  SBLog(@"animation should resume.");
	[self __debug_resumeLayer:self.layer];
}

- (void)__debug_pauseLayer:(CALayer *)layer
{
	CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
	layer.speed = 0.0;
	layer.timeOffset = pausedTime;
}

- (void)__debug_resumeLayer:(CALayer *)layer
{
	CFTimeInterval pausedTime = [layer timeOffset];
	layer.speed = 1.0;//
	layer.timeOffset = 0.0;
	layer.beginTime = 0.0;
	CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
	layer.beginTime = timeSincePause;
}


@end
