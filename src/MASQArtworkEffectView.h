#import "Interfaces.h"

@interface MASQArtworkEffectView : UIImageView
@property (nonatomic, retain) UIImageView * imageHost;
@property (nonatomic, retain) id radiusHost;
@property (nonatomic, retain) UIView * frameHost;

@property (nonatomic, assign) NSString * identifier;
// @property (nonatomic, assign) NSString * styleKey;
@property (nonatomic, retain) UIVisualEffectView * effectView;
// -(id)initWithFrame:(CGRect)arg1;
-(id)initWithFrameHost:(UIView *)arg1 radiusHost:(id)arg2  imageHost:(id)arg3;
-(id)effectViewWithEffect:(id)arg1;

-(void)updateEffect;
-(void)updateEffectWithStyle:(int)arg1;
-(void)updateArtwork:(id)arg1;
-(void)updateVisibility;
-(void)updateRadius;

-(void)setFrameHost:(UIView *)arg1;
// -(void)setImageDelegate:(id)arg1;
-(void)setRadiusHost:(id)arg1;
@end
