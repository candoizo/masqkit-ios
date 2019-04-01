#import "../src/MASQArtworkView.h"
#import "Interfaces.h"

%ctor {
  if (!%c(MASQArtworkView)) //if not loaded we need to do so
  dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
}

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
  if (arg1 && self.masqArtwork && arg1 == act)
  {
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
