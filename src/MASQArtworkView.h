#import "Interfaces.h"

@interface MASQArtworkView : UIView
@property (nonatomic, assign) BOOL hasAnimation; // this marks if the imageview is dirty because ca frames break it
@property (nonatomic, assign) BOOL isAnimating; // this keeps track if i'ts actually animating or not
@property (nonatomic, assign) BOOL activeAudio; // this keeps track of if audio is playing or not
@property (nonatomic, assign) BOOL wantsAnimation;
// @property (nonatomic, assign) NSNumber * activeTrack;
@property (nonatomic, assign) NSString * identifier;
@property (nonatomic, assign) NSBundle * currentTheme;
@property (nonatomic, assign) unsigned long hashCache;
@property (nonatomic, retain) UIView * frameHost;
@property (nonatomic, retain) UIView * centerHost;
@property (nonatomic, retain) UIImageView * imageHost;
@property (nonatomic, retain) UIImageView * artworkImageView;
@property (nonatomic, retain) UIButton * overlayView;
@property (nonatomic, retain) UIButton * underlayView;
@property (nonatomic, retain) UIView * containerView;
@property (nonatomic, assign) float ratio;
-(id)initWithThemeKey:(NSString *)arg1;
-(id)initWithThemeKey:(NSString *)arg1 frameHost:(id)arg2 imageHost:(id)arg3;

-(void)updateCenter;
-(void)updateTheme;
-(void)updateFrame;
-(void)updateArtwork:(UIImage *)img;
-(void)tapAnimate;

// -(float)ratio;

-(UIView *)containerView;
-(UIButton *)overlayView;
-(UIButton *)underlayView;

-(id)maskImage;
-(id)overlayImage;
-(id)underlayImage;
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

// @property (nonatomic, assign) BOOL debugged;
@property (nonatomic, assign) BOOL neverAnimate;
@end
