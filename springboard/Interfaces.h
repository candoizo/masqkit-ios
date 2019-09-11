#import "../src/MASQArtworkView.h"
#import "../src/MASQArtworkEffectView.h"

static NSString * const kControlCenterKey = @"CC";
static NSString * const kDashBoardKey = @"LS";

@interface SBMediaController (Private)
-(instancetype)sharedInstance;
-(BOOL)hasTrack;
@end

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

@property (nonatomic, retain) MASQArtworkEffectView * masqBackground;
@end


@interface MRPlatterViewController : UIViewController
@property (nonatomic) UIView * topDividerView;
@property (nonatomic) UIView * backgroundView;
@property (nonatomic) MediaControlsHeaderView * nowPlayingHeaderView;
@property (assign,nonatomic) int mediaControlsPlayerState; // only exists below 11.1.12
@property (nonatomic) id delegate;
@property (nonatomic) float trueWidth;
@property (nonatomic) int style;
-(BOOL)onScreen;

@property (nonatomic, retain) MASQArtworkEffectView * masqBackground;
@property (nonatomic, assign) CGFloat _continuousCornerRadius;
@end


@interface CALayer (ElevenPlus)
-(int)maskedCorners;
@end
