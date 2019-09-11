@interface SBDashBoardMediaControlsViewController : UIViewController
@property (nonatomic, retain) MASQArtworkView * masqArtwork;
@end

@interface MPULockScreenMediaControlsViewController : UIViewController
-(id)artworkView;
@property (nonatomic, retain) MASQBlurredImageView * masqBackground;
@end

@interface SBDashBoardMainPageContentViewController : UIViewController
@property (nonatomic) BOOL showingMediaControls;
@property (nonatomic, retain) MASQBlurredImageView * masqBackground;
@end

@interface MPUControlCenterMediaControlsView : UIView
@property (nonatomic) int displayMode;
@property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(id)artworkView;
@end

@interface MPUControlCenterMediaControlsViewController : UIViewController
@property (nonatomic, retain) MASQBlurredImageView * masqBackground;
@end

@interface CCUIControlCenterPageContainerViewController : UIViewController
@property (nonatomic) UIViewController * contentViewController;
@end
