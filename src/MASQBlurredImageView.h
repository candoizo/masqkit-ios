@interface MASQBlurredImageView : UIImageView
@property (nonatomic, assign) NSString * styleKey;
@property (nonatomic, retain) UIVisualEffectView * effectView;
-(id)initWithFrame:(CGRect)arg1 layer:(CALayer *)layer;
-(id)effectViewWithEffect:(id)arg1;
-(void)updateEffectWithKey;
-(void)updateEffectWithStyle:(int)arg1;
@end
