@interface MusicNowPlayingControlsViewController : UIViewController
@property (nonatomic, retain) MASQArtworkView* masqArtwork;
-(id)artworkView;
@end

@interface Artwork : UIView
@property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(id)imageSub;
@end


@interface Mini : UIViewController
@property (nonatomic, retain) MASQArtworkView * masqArtwork;
@end
