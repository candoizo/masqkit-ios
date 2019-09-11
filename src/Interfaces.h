@interface SBApplication : UIApplication
-(NSString *)bundleIdentifier;
@end

@interface SBMediaController : NSObject
+(SBMediaController *)sharedInstance;
-(SBApplication *)nowPlayingApplication;
-(BOOL)hasTrack;
@end

@interface SBLockStateAggregator : NSObject
+(instancetype)sharedInstance;
-(int)lockState;
@end

@interface SBCoverSheetPresentationManager
+(id)sharedInstance;
-(BOOL)isVisible;
-(void)setCoverSheetPresented:(BOOL)arg1 animated:(BOOL)arg2 withCompletion:(id)arg3;
@end

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
