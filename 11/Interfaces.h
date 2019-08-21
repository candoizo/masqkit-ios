#import "../src/MASQThemeManager.h"
#import "../src/MASQArtworkView.h"
#import "../src/MASQArtworkBlurView.h"

@interface MediaControlsHeaderView : UIView
@property (nonatomic, retain) MASQArtworkView * masqArtwork;
@property (nonatomic,retain) UIImageView * artworkView;
@property () UIView * artworkBackgroundView;
@property (nonatomic) int style; // ios 12 only

-(BOOL)headerViewOnScreen; // < 11.2 only
@end

@interface MediaControlsPanelViewController : UIViewController
@property (nonatomic) float trueWidth;
@property (nonatomic) UIView * topDividerView;
@property (nonatomic) UIView * backgroundView;
@property (nonatomic) MediaControlsHeaderView * headerView;
@property (nonatomic) id delegate;
@property (assign,nonatomic) int mediaControlsPlayerState; // only exists below 11.1.12
@property (nonatomic) int style;
-(BOOL)onScreen;

@property (nonatomic, retain) MASQArtworkBlurView * masqBackground;
@end

// @interface MASQArtworkBlurView : UIImageView
// @end

// ios 12.4 (maybe 12.2)+
@interface MRPlatterViewController : UIViewController
@property (nonatomic) UIView * topDividerView;
@property (nonatomic) UIView * backgroundView;
@property (nonatomic) MediaControlsHeaderView * nowPlayingHeaderView;
@property (assign,nonatomic) int mediaControlsPlayerState; // only exists below 11.1.12
@property (nonatomic) id delegate;
@property (nonatomic) float trueWidth;
@property (nonatomic) int style;
// -(BOOL)onScreen;

@property (nonatomic, retain) MASQArtworkBlurView * masqBackground;
@property (nonatomic, assign) CGFloat _continuousCornerRadius;
@end


@interface CALayer (Newish)
-(int)maskedCorners;
@end
