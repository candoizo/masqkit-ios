@interface MASQArtworkBlurView : UIImageView
@property (nonatomic, assign) NSString * identifier;
// @property (nonatomic, assign) NSString * styleKey;
@property (nonatomic, retain) UIVisualEffectView * effectView;
-(id)initWithFrame:(CGRect)arg1 layer:(CALayer *)layer;
-(id)effectViewWithEffect:(id)arg1;
-(void)updateEffectWithKey;
-(void)updateEffectWithStyle:(int)arg1;
-(void)updateArtwork;


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
