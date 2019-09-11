#import "../src/MASQArtworkView.h"
#import "Interfaces.h"

/*
  Changelog:
  - Updated to support the latest version
  - Fixes to the display manager, artwork will now be hidden when a track has a background video

  I need to use like
  SPTNowPlayingContentLayerViewModel

  something like

  SPTNowPlayingContentLayerViewController.model.currentItemIndexPath
*/

@interface UIView (SpotifyCategory)
-(id)spt_imageRepresentation; // returns a uiimage
@end

@interface SPTNowPlayingContentLayerViewModel : NSObject
@property (nonatomic, retain) id delegate;
-(NSIndexPath *)currentItemIndexPath;
-(id)currentTrack;
@end

@interface SPTNowPlayingCoverArtCell (Hooks)
@property (nonatomic, retain) MASQArtworkView * masqArtwork;
@end


@interface SPTNowPlayingContentLayerViewController : UIViewController
@property (nonatomic, retain) SPTNowPlayingContentLayerViewModel * viewModel;
@property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(UICollectionView *)collectionView; // this holds all the artworks

-(SPTNowPlayingCoverArtCell *)_masq_activeFrame;
-(id)_masq_activeImage;
-(id)_masq_activeImageView;
-(id)_masq_activeCenter;
-(void)addMasq;
@end

%ctor {
  if (!%c(MASQArtworkView))
  dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
}

%hook SPTNowPlayingCoverArtCell
%property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(id)imageView {
  UIImageView * orig = %orig;

  if (!self.masqArtwork)
  {
    MASQArtworkView * art = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"Spotify" frameHost:orig imageHost:orig];
    [orig addSubview:self.masqArtwork = art];
  }
  return orig;
}
%end


%hook SPTNowPlayingContentLayerViewModel
// -(void)nowPlayingModel:(id)arg1 didMoveToRelativeTrack:(id)arg2 {
//
//   %orig;
//
//   // if ([self.delegate isKindOfClass:%c(SPTNowPlayingContentLayerViewController)])
//   // {
//   //   SPTNowPlayingContentLayerViewController * del = self.delegate;
//   //   if (del.masqArtwork)
//   //   {
//   //     UIImageView * view = [del _masq_activeImageView];
//   //     [del.masqArtwork updateArtwork:view.image];
//   //   }
//     // else if (!del.masqArtwork)[del addMasq];
//   // }
// }

// -(void)nowPlayingModelDidUpdateMetadata:(id)arg1 {
//   %orig;
//
//   if ([self.delegate isKindOfClass:%c(SPTNowPlayingContentLayerViewController)])
//   {
//     SPTNowPlayingContentLayerViewController * del = self.delegate;
//     if (del.masqArtwork)
//     {
//       UIImageView * view = [del _masq_activeImageView];
//       [del.masqArtwork updateArtwork:view.image];
//     }
//     // else if (!del.masqArtwork)[del addMasq];
//   }
// }
%end

%hook SPTNowPlayingContentLayerViewController
%property (nonatomic, retain) MASQArtworkView * masqArtwork;

%new
-(SPTNowPlayingCoverArtCell *)_masq_activeFrame {
    return self.collectionView.visibleCells[0];
}

%new
-(id)_masq_activeImage {
  UIView * view = self.collectionView.visibleCells[0];
  return view.spt_imageRepresentation;
}

%new
-(id)_masq_activeImageView {
  return [self _masq_activeFrame].imageView;
}

%new
-(id)_masq_activeCenter {
  return [self _masq_activeFrame].windowedContentView;
}

-(void)setupCollectionView {

  %orig;

  self.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"Spotify" frameHost:self.collectionView imageHost:nil];
  [self.view addSubview:self.masqArtwork];
  // [self addMasq];
}

%new
-(void)addMasq {

  if (!self.masqArtwork)
  {

    UIView * v = self.collectionView.visibleCells[0];

    // id view = [self _masq_activeImageView];
    self.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"Spotify" frameHost:v imageHost:v];
    self.masqArtwork.centerHost = [self _masq_activeCenter];

    [self.view addSubview:self.masqArtwork];
  }
}

// -(void)reloadDataAndLayoutForIndexPath:(NSIndexPath *)arg1 relativeMovement:(int)arg2 {
//   %orig;
// //
//   if (!self.masqArtwork)
// //   [self.masqArtwork updateArtwork:nil];
// //     // if ([self _masq_activeView] && [self _masq_activeImage])
// //     // NSLog(@"HI");
//     [self addMasq];
// }

// -(void)applicationWillEnterForeground:(id)arg1 {
//   %orig;
//
// }
//
// -(void)collectionView:(UIView *)arg1 willDisplayCell:(id)arg2 forItemAtIndexPath:(NSIndexPath *)arg3 {
//   %orig;
//
//
//   if (arg1.subviews.count > 0)
//   {
//     for (UIView * v in arg1.subviews)
//     {
//       if ( [v isKindOfClass:%c(MASQArtworkView)])
//       {
//         // if (self.collectionView.visibleCells.count > 0)
//         // {
//         //   MASQArtworkView * art = (MASQArtworkView *)v;
//         //   if (!art.frameHost && !art.imageHost)
//         //   {
//         //     UIImageView *av = [self _masq_activeImage];
//         //     art.frameHost = av;
//         //     art.imageHost = av;
//         //   }
//         // }
//       }
//     }
//   }
//
//   // if (self.masqArtwork)
//   // [self.masqArtwork updateArtwork:[self _masq_activeImage]];
//       // if ([self _masq_activeFrame] && [self _masq_activeCenter])
//       // {
//       //   // [self addMasq];
//       // }
// }

// hide artwork with sledgehammer BV)
// -(void)loadView {
//   %orig;
//
//   if (self.collectionView)
//   {
//     self.collectionView.hidden = YES;
//     for (UIView * v in self.collectionView.subviews)
//     {
//       if (!v.hidden && [v isKindOfClass:NSClassFromString(@"SPTNowPlayingCoverArtCell")])
//       v.hidden = YES;
//     }
//
//     // [self.view addSubview:self.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"Spotify" frameHost:nil imageHost:nil]];
//
//     // if ([self _masq_activeFrame] && [self _masq_activeCenter] && [self _masq_activeImageView])
//     // {
//     //   [self addMasq];
//     // }
//   }
// }

// -(void)viewWillLayoutSubviews {
//   %orig;
//
// }

// -(void)setupUI {
//
//   %orig;
//
//   if (self.collectionView)
//   {
//     MASQArtworkView * art = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"Spotify" frameHost:nil imageHost:nil];
//     art.centerHost = [self ]
//     [self.collectionView addSubview:art];
//   }
// }

// hiding the artwork views but not the videos
// -(id)collectionView {
//   UICollectionView * orig = %orig;
//
//   for (UIView * v in orig.subviews)
//   {
//     if (!v.hidden && [v isKindOfClass:NSClassFromString(@"SPTNowPlayingCoverArtCell")])
//     v.hidden = YES;
//   }
//
//
//   MASQArtworkView * art = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"Spotify" frameHost:nil imageHost:nil];
//   // SPTNowPlayingCoverArtCell * center = orig.visibleCells[0];
//   // art.centerHost = center.windowedContentView;
//   [self.collectionView addSubview:art];
//
//   // unhide this mofo for videos if it was
//   if (orig.hidden)
//   orig.hidden = NO;
//
//   return orig;
// }

%end

%hook SPTNowPlayingCoverArtCell
-(void)setHidden:(BOOL)arg1 {
  %orig(YES);
}

-(void)setAlpha:(float)arg1 {
  %orig(0);
}
%end








// ios 11+ probably legacy but w/e
%hook SPTNowPlayingContentView
// %property (nonatomic, assign) CGPoint original
%property (nonatomic, retain) MASQArtworkView * masqArtwork;
%new
-(void)addMasq {
  if (!self.masqArtwork)
  {
    SPTNowPlayingContentCell * act = [self activeContentHost];
    self.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"Spotify" frameHost:act.placeholderImageView imageHost:act.coverArtContent];

    // only needed for especially difficult views that pretend to be at 0,0
    self.masqArtwork.centerHost = act.contentUnitView;
    [self addSubview:self.masqArtwork];
  }
}

-(void)updateCoverArtsAnimated:(BOOL)arg1 includeVideo:(BOOL)arg2
{
  %orig;
  if ([self activeContentHost].coverArtContent.bounds.size.width && !self.masqArtwork)
  [self addMasq];
}

-(void)setAppearanceForCell:(id)arg1 isVideo:(BOOL)arg2 trackBelongsToContext:(BOOL)arg3 {
  %orig;

  SPTNowPlayingContentCell * act = [self activeContentHost];
  if (arg1 && self.masqArtwork && arg1 == act && act.coverArtContent)
  {
    if (act.coverArtContent != self.masqArtwork.imageHost)
    {
      self.masqArtwork.imageHost = act.coverArtContent;
    }

    [self.masqArtwork updateArtwork:act.coverArtContent.image];
  }
}

%new
-(SPTNowPlayingContentCell *)activeContentHost {
  SPTNowPlayingContentCell * cell = [self cellAtRelativePage:0];
  return cell;
}
%end

//hide artwork stuff
%hook SPTNowPlayingContentCell
-(id)coverArtContent {
  UIView * orig = %orig;
  if ([self.delegate respondsToSelector:@selector(masqArtwork)])
  orig.hidden = YES;
  return orig;
}

-(id)placeholderImageView {
    UIView * orig = %orig;
    orig.hidden = YES;
    return orig;
}
%end

// something about this is causing problems, worse its called test so its gunna change one day D=
// -[SPTRadioTestManagerImplementation isRadioURITransitionEnabled] // temptation
// -[SPTRadioPlaybackService startDecoratedRadioStation: player: startedFromElement: atIndex:0xffffffffffffffff completion:0x1d6e72b80] new radio station view made
// %hook SPTRadioPlaybackService
// -(void)startDecoratedRadioStation:(id)arg1 player:(id)arg2 startedFromElement:(id)arg3 atIndex:(id)arg4 completion:(id)arg5
// %end
//
//
// // ios 10? old devices? dunno
// @interface SPTNowPlayingViewController : UIViewController
// @property (nonatomic, retain) MASQArtworkView * masqArtwork;
// -(SPTNowPlayingContentView *)spt_nowPlayingCoverArtView;
// -(SPTNowPlayingContentCell *)activeContentHost;
// @end
// %hook SPTNowPlayingViewController
// %property (nonatomic, retain) MASQArtworkView * masqArtwork;
// %new
// -(void)addMasq {
//   if (!self.masqArtwork)
//   {
//     self.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"Spotify" frameHost:[self spt_nowPlayingCoverArtView] imageHost:[self activeContentHost].coverArtContent];
//     // only needed for especially difficult views that pretend to be at 0,0
//     self.masqArtwork.centerHost = [self activeContentHost].contentUnitView;
//     [self.view addSubview:self.masqArtwork];
//   }
// }
//
// %new
// -(SPTNowPlayingContentCell *)activeContentHost {
//   SPTNowPlayingContentView * cell = [self spt_nowPlayingCoverArtView];
//   return [cell cellAtRelativePage:0];
// }
// %end
