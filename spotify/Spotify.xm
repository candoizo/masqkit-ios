#import "../src/MASQArtworkView.h"
#import "Interfaces.h"

%ctor {
  if (!%c(MASQArtworkView)) //if not loaded we need to do so
  dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
}

%hook SPTNowPlayingContentView
%property (nonatomic, retain) MASQArtworkView * masqArtwork;

%new
-(void)addMasq {
  if (!self.masqArtwork)
  {
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
  if ([self activeContentHost].coverArtContent.bounds.size.width && !self.masqArtwork)
  [self addMasq];
}

-(void)setAppearanceForCell:(id)arg1 isVideo:(BOOL)arg2 trackBelongsToContext:(BOOL)arg3 {
  %orig;

    if (arg1 && self.masqArtwork && arg1 == [self activeContentHost])
    {
      SPTNowPlayingContentCell * act = [self activeContentHost];
      [self.masqArtwork updateArtwork:act.coverArtContent.image];
      // [self.masqArtwork updateTheme];
    }
}

%new
-(SPTNowPlayingContentCell *)activeContentHost {
  SPTNowPlayingContentCell * cell = [self cellAtRelativePage:0];
  return cell;
}
%end

//hide artwork
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
