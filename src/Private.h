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
