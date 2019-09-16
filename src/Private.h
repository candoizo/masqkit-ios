@interface UIApplication (Private)
+(id)sharedApplication;
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
@end

@interface UIView (Private)
-(void)_setContinuousCornerRadius:(int)arg1;
-(float)_continuousCornerRadius;
@end


@interface UIVisualEffectView (Private)
-(UIBlurEffect *)effect;
@end


@interface UIVisualEffect (Private)
-(int)_style;
@end


@interface CALayer (Private)
-(int)maskedCorners;
@end

@interface UIImage (Private)
+ (id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2 scale:(CGFloat)arg3;
+(id)imageNamed:(id)arg1 inBundle:(id)arg2;
@end
