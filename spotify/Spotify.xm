#import "../src/MASQArtworkView.h"
#import "Interfaces.h"

// @TODO
// hard to test but potentially skipping when lagging can make it lose track once?

%ctor {
  if (!%c(MASQArtworkView)) //if not loaded we need to do so
  dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
}

// ios 11+
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
