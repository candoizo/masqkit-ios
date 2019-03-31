#import "../src/MASQArtworkView.h"


@interface SPTNowPlayingContentCell
// [SPTNowPlayingContentCell setCoverArtContent:0x10cb7b8c0 hideCoverArt:0x0 isVideo:0x0 track:0x1c024f750 imageURL:0x1d5696ad0 animated:0x1]
@property (nonatomic) UIImageView * placeholderImageView; //perfect agnostic view that already mirrors the frame we want
-(id)spt_imageRepresentation; //hmm

-(BOOL)shouldShowCoverArtView;
-(BOOL)shouldContentProvidersReplaceCoverArt;

-(UIImageView *)coverArtContent;
-(UIView *)contentUnitView; // this is the view that's centered
@end

@interface SPTNowPlayingCoverArtViewCell : UIView
@property (nonatomic) UIView * delegate;
@property (nonatomic) MASQArtworkView * masqArtwork;
@property (nonatomic) UIImageView * coverArtContent;
@property (nonatomic) UIImageView * placeholderImageView;
// @property (nonatomic, assign) BOOL hasMasq;
@end

%ctor {
  if (!%c(MASQArtworkView)) //if not loaded we need to do so
  dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
}

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

@interface SPTNowPlayingDefaultContentViewController : UIViewController
@property (nonatomic) SPTNowPlayingContentView * contentView;
@property (nonatomic) BOOL shouldOverrideVideoAppearance;
@property (nonatomic) BOOL useLargeArtwork;
@property (nonatomic) MASQArtworkView * masqArtwork;
-(BOOL)isShowingOverlayForCurrentPage;
@end

%hook SPTNowPLayingContentCell

%hook SPTNowPlayingContentView
%property (nonatomic, retain) MASQArtworkView * masqArtwork;
%new
-(SPTNowPlayingContentCell *)activeContentHost {
  SPTNowPlayingContentCell * cell = [self cellAtRelativePage:0];
  return cell;
}

%new
-(void)addMasq {
  if (!self.masqArtwork)
  {
    SPTNowPlayingContentCell * act = [self activeContentHost];
    MASQArtworkView * art = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"MP" frameHost:act.placeholderImageView imageHost:act.coverArtContent];
    // art.usesDirectImage = YES;
    self.masqArtwork = art;
    self.masqArtwork.center = act.contentUnitView.center;
    [self addSubview:art];

    // UIImage * img = [[self activeContentHost] spt_imageRepresentation];
    // [self.masqArtwork updateArtwork:img];
    // [self.masqArtwork updateTheme];
  }
}

-(void)updateCoverArtsAnimated:(BOOL)arg1 includeVideo:(BOOL)arg2
{
  %orig;
  if (self.masqArtwork)
  {
    SPTNowPlayingContentCell * act = [self activeContentHost];
    [self.masqArtwork updateArtwork:act.coverArtContent.image];
  }
}
// [SPTNowPlayingContentView updateCoverArtsAnimated:0x1 includeVideo:0x1]
%end

%hook SPTNowPlayingDefaultContentViewController
// -(void)shouldUpdateBlurConstituentForRelativePosition:(id)arg1 toImage:(id)arg2 withURL:(id)arg3 {
  // %orig;
  // if (self.contentView.masqArtwork && arg2)
  // {
  //   HBLogDebug(@"arg2 %@", arg2);
  //   // if (arg2) [self.contentView.masqArtwork updateArtwork:arg2];
  // }
// }
// %property (nonatomic, retain) MASQArtworkView * masqArtwork;
// -(void)viewWillAppear:(BOOL)arg1 {
//   if (!self.masqArtwork)
//   {
//     MASQArtworkView * art = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"MP" frameHost:self.view imageHost:self.view];
//     self.masqArtwork = art;
//   }
// }
//
// -(void)setContentView:(SPTNowPlayingContentView *)arg1 {
//   %orig;
//   if ([arg1 isKindOfClass:%c(SPTNowPlayingContentView)] && !arg1.masqArtwork)
//   {
//     [arg1 addMasq];
//     if (arg1.masqArtwork)
//     {
//       UIImage * img = [[arg1 activeContentHost] spt_imageRepresentation];
//       [arg1.masqArtwork updateArtwork:img];
//     }
//   }
// }

// -(void)contentViewDidReloadData:(SPTNowPlayingContentView *)arg1 {
//   %orig;
//   if (self.masqArtwork)
//   {
//     // SPTNowPlayingContentCell * act = arg1.activeContentHost;
//     // self.masqArtwork.imageHost = act.coverArtContent;
//     [self.masqArtwork updateArtwork:nil];
//   }
//   // %log;
//
// }

// -(void)updateContentDecorationViewControllerFrame {
//
// }
%end

// %hook SPTNowPlayingContentCell
// -(void)setCoverArtContent:(id)arg1 hideCoverArt:(BOOL)arg2 isVideo:(BOOL)arg3 track:(id)arg4 imageURL:(id)arg5 animated:(BOOL)arg6 {
//   %orig;
// }
// %end

// %hook [SPTNowPlayingContentCell setCoverArtContent:0x10cb7b8c0 hideCoverArt:0x0 isVideo:0x0 track:0x1c024f750 imageURL:0x1d5696ad0 animated:0x1]
// %end
// SPTNowPlayingPlaybackController
// isPaused
//

// ios 11 +
// %hook MRNowPlayingPlayerClient
// -(void)setNowPlayingArtwork:(NSData *)arg1 {
//   %log;
//   %orig;
// }
//
//
// -(void)setPlaybackState:(long long)arg1 {
//   %log;
//   %orig;
// }
// %end

/*
   So it seem that in SpringBoard one can use
   SBMediaController

   both have -(void)setNowPlayingInfo

   and in Apps you can use
   MRNowPlayingPlayerClient


*/

/*
//Can get them from a MRNowPlayingClient.playerClients
MRNowPlayingPlayerClient
-(NSData *)nowPlayingArtwork;


// wow i should definitly make a part of NS
-[MRNowPlayingPlayerClient setNowPlayingInfo:0x1cc229000]
*/


// %hook SPTNowPlayingCoverArtViewCell
// %property (nonatomic, retain) MASQArtworkView * masqArtwork;
// -(void)setCoverArtContent:(id)arg1 {
//   %orig;
//   if (!self.masqArtwork) {
//     self.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"MP" frameHost:self imageHost:arg1];
//     // MASQArtworkView * masq = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"MP" frameHost:self imageHost:arg1];
//     // [self addSubview:masq];
//     // self.hasMasq = YES;
//     [self addSubview:self.masqArtwork];
//   }
// }

// -(void)setFrame:(CGRect)arg1 {
//   %orig(CGRectMake(arg1.origin.x, arg1.origin.y, arg1.size.width*0.825, arg1.size.height*0.825));
// }

// -(void)layoutSubviews {
//   %orig;
//   self.placeholderImageView.hidden = YES;
//   if (self.masqArtwork) {
//     self.masqArtwork.bounds = CGRectMake(0, 0, self.masqArtwork.bounds.size.width, self.masqArtwork.bounds.size.height);
//     self.masqArtwork.center = [self convertPoint:self.superview.center toView:self.masqArtwork]; //YAY
//   }
// }
//
// %new
// -(void)setHasMasq:(BOOL)arg1 {
//     objc_setAssociatedObject(self, @selector(hasMasq), @(arg1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
// }
//
// %new
// - (BOOL)hasMasq {
//     return [objc_getAssociatedObject(self, @selector(hasMasq)) boolValue];
// }
// %end

// @interface SPTVideoSurfaceImpl : UIView
// @property (nonatomic, retain) MASQArtworkView * masqArtwork;
// @property (nonatomic, assign) BOOL hasMasq;
// @end

// %hook SPTVideoSurfaceImpl
// -(void)refreshVideoRect {
//   %orig;
//   %log;
//   self.transform = CGAffineTransformMakeScale(0.7, 0.7);
//   // if (![self masqArtwork]) {
//     // self.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"MP" frameHost:self imageHost:self];
//     // [self addSubview:self.masqArtwork];
//   // }
//   if (!self.hasMasq) {
//     HBLogDebug(@"no masq!");
//     MASQArtworkView * masq = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"MP" frameHost:self imageHost:self];
//     [self.superview addSubview:masq];
//     self.hasMasq = YES;
//   }
// }
//
// %new
// -(void)setMasqArtwork:(id)arg1 {
//     HBLogDebug(@" setting %@", arg1);
//     objc_setAssociatedObject(self, @selector(masqArtwork), arg1, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//     HBLogDebug(@"set!");
// }
//
// %new
// -(id)masqArtwork {
//   return objc_getAssociatedObject(self, @selector(masqArtwork));
// }
//
// %new
// -(void)setHasMasq:(BOOL)arg1 {
//     objc_setAssociatedObject(self, @selector(hasMasq), @(arg1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
// }
//
// %new
// - (BOOL)hasMasq {
//     return [objc_getAssociatedObject(self, @selector(hasMasq)) boolValue];
// }
// %end

// %hook SPTVideoDisplayView
//
// %end
//
// %hook SPTNowPlayingCoverArtImageContentView
//
// %end
//
// %hook SPTNowPlayingScrollViewController
// -(id)nowPlayingViewController {
//   id orig = %orig;
//   HBLogDebug(@"%@", ((UIView*)orig).class);
//   return orig;
// }
// %end
