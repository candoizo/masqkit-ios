@interface MusicNowPlayingControlsViewController : UIViewController
@property (nonatomic, retain) MASQArtworkView* masqArtwork;
-(id)artworkView;
@property (nonatomic, retain) MASQArtworkEffectView * masqBackground;
+(instancetype)sharedInstance;
@end

@interface Artwork : UIView
@property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(id)imageSub;
@end


@interface Mini : UIViewController
@property (nonatomic, retain) MASQArtworkView * masqArtwork;
@end
