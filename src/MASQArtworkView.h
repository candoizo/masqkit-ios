@interface SBMediaController : NSObject
+(SBMediaController *)sharedInstance;
-(UIApplication *)nowPlayingApplication;
@end

@interface UIApplication (Private)
+(id)sharedApplication;
-(id)bundleIdentifier;
- (BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
@end

@interface MASQArtworkView : UIView
@property (nonatomic, assign) BOOL usesDirectImage;
// @property (nonatomic, assign) BOOL disabled;
@property (nonatomic, assign) NSString * identifier; //themeKey
@property (nonatomic, assign) NSBundle * currentTheme;
@property (nonatomic, assign) unsigned long hashCache;
@property (nonatomic, retain) UIView * frameHost;
@property (nonatomic, retain) UIImageView * imageHost;
@property (nonatomic, retain) UIImageView * artworkImageView;
@property (nonatomic, retain) UIButton * overlayView;
@property (nonatomic, retain) UIButton * underlayView;
@property (nonatomic, retain) UIView * containerView;
-(id)initWithThemeKey:(NSString *)arg1;
-(id)initWithThemeKey:(NSString *)arg1 frameHost:(id)arg2 imageHost:(id)arg3;

-(void)updateTheme;
-(void)updateFrame;
-(void)updateArtwork:(UIImage *)img;

-(float)ratio;
// -(BOOL)themeUpdated;

-(UIView *)containerView;
-(UIButton *)overlayView;
-(UIButton *)underlayView;

-(id)maskImage;
-(id)overlayImage;
-(id)underlayImage;
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
@end
