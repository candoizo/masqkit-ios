#import "../src/MASQArtworkView.h"
#import "Interfaces.h"

%ctor {
  if (!%c(MASQArtworkView)) //if not loaded we need to do so
  dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
}

// make something so that it updates the theme ???

%hook SPTNowPlayingContentCell
-(id)coverArtContent {
  UIView * orig = %orig;
  if ([self.delegate respondsToSelector:@selector(masqArtwork)])
  {
    // MASQArtworkView * masq = ((SPTNowPlayingContentView *)self.delegate).masqArtwork;
    // if (masq) orig.hidden = !masq.disabled;
    orig.hidden = YES;
  }
  // orig.hidden = YES;
  return orig;
}

-(id)placeholderImageView {
    UIView * orig = %orig;
    orig.hidden = YES;
    return orig;
}
%end

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
    HBLogDebug(@"ach %@", [self activeContentHost]);
    SPTNowPlayingContentCell * act = [self activeContentHost];
    self.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"MP" frameHost:act.placeholderImageView imageHost:act.coverArtContent];
    self.masqArtwork.center = act.contentUnitView.center;
    self.masqArtwork.userInteractionEnabled = NO;
    [self addSubview:self.masqArtwork];
  }
}

-(void)updateCoverArtsAnimated:(BOOL)arg1 includeVideo:(BOOL)arg2
{
  %orig;
  if ([self activeContentHost].coverArtContent.bounds.size.width && !self.masqArtwork) [self addMasq];
  else if (self.masqArtwork)
  {
    SPTNowPlayingContentCell * act = [self activeContentHost];
    [self.masqArtwork updateArtwork:act.coverArtContent.image];
    if (arg2)
    {
      // HBLogDebug(@"This has a video!");
    }
  }

}

-(void)setAppearanceForCell:(id)arg1 isVideo:(BOOL)arg2 trackBelongsToContext:(BOOL)arg3 {
  %orig;

    if (arg1 && self.masqArtwork)
    {
      SPTNowPlayingContentCell * act = [self activeContentHost];
      [self.masqArtwork updateArtwork:act.coverArtContent.image];
      // [self.masqArtwork updateTheme];
    }
}

// -(void)setVisible:(BOOL)arg1 {
//   %orig;
//   if (arg1 && self.masqArtwork)
//   {
//     SPTNowPlayingContentCell * act = [self activeContentHost];
//     [self.masqArtwork updateArtwork:act.coverArtContent.image];
//     // [self.masqArtwork updateTheme];
//   }
// }
%end
