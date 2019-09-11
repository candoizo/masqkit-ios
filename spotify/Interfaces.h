
// more of that
@interface SPTNowPlayingContentCell : UIView
// [SPTNowPlayingContentCell setCoverArtContent:0x10cb7b8c0 hideCoverArt:0x0 isVideo:0x0 track:0x1c024f750 imageURL:0x1d5696ad0 animated:0x1]
@property (nonatomic) id delegate;
@property (nonatomic) UIImageView * placeholderImageView; //perfect agnostic view that already mirrors the frame we want
-(id)spt_imageRepresentation; //hmm

-(BOOL)shouldShowCoverArtView;
-(BOOL)shouldContentProvidersReplaceCoverArt;

-(UIImageView *)coverArtContent;
-(UIView *)contentUnitView; // this is the view that's centered
@end

// individual views
@interface SPTNowPlayingCoverArtViewCell : UIView
@property (nonatomic) UIView * delegate;
@property (nonatomic) MASQArtworkView * masqArtwork;
@property (nonatomic) UIImageView * coverArtContent;
@property (nonatomic) UIImageView * placeholderImageView;
// @property (nonatomic, assign) BOOL hasMasq;
@end

// artwork container
@interface SPTNowPlayingContentView : UIView
@property (nonatomic) MASQArtworkView * masqArtwork;
-(NSMutableArray *)contentCells; /* has SPTNowPlayingContentCell */
-(BOOL)hasFullscreenVideoAtCurrentPage;
-(BOOL)hasVideoAtCurrentPage;
-(BOOL)visible;
-(BOOL)active;
-(id)cellAtRelativePage:(int)arg1;
-(id)createContentCell;
-(SPTNowPlayingContentCell *)activeContentHost;
-(void)nowPlayingContentCell:(id)arg1 didChangeContent:(id)arg2;

-(void)addMasq;
@end

// main controller
@interface SPTNowPlayingDefaultContentViewController : UIViewController
@property (nonatomic) SPTNowPlayingContentView * contentView;
@property (nonatomic) BOOL shouldOverrideVideoAppearance;
@property (nonatomic) BOOL useLargeArtwork;
@property (nonatomic) MASQArtworkView * masqArtwork;
-(BOOL)isShowingOverlayForCurrentPage;
@end


@interface SPTNowPlayingCoverArtCell : UIView
-(UIImageView *)imageView;
-(UIView *)windowedContentView;
@end
