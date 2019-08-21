@interface MASQArtworkBlurView : UIImageView
@property (nonatomic, retain) UIImageView * imageHost;
@property (nonatomic, assign) NSString * identifier;
// @property (nonatomic, assign) NSString * styleKey;
@property (nonatomic, retain) UIVisualEffectView * effectView;
-(id)initWithFrame:(CGRect)arg1;
-(id)effectViewWithEffect:(id)arg1;
-(void)updateEffectWithKey;
-(void)updateEffectWithStyle:(int)arg1;
-(void)updateArtwork:(id)arg1;
-(void)updateVisibility;

// -(id)initWithFrame:(id)arg1;
// -(id)initWithFrame:(id)arg1 style:(id)arg2;
//
// -(int)style;
// -(id)frameHost;
// -(id)radHost;
//
// -(void)observeValueForKeyPath:(id)arg1 context:(id)arg2;
// -(void)updateStyle:(id)arg1;
@end

@interface UIView (Private)
-(void)_setContinuousCornerRadius:(int)arg1;
@end


@interface UIVisualEffectView (Private)
-(UIBlurEffect *)effect;
@end


@interface UIVisualEffect (Private)
-(int)_style;
@end
