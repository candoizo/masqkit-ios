#import "../src/MASQArtworkView.h"
#import "Interfaces.h"

// @TODO
// 11.2
// loses track of the changes when switching from custom list to radio :(
// if you skip a lot if can lose track

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
    // good intentions but too late when someone opens from the bg
    // if (act.coverArtContent.image.hash != self.masqArtwork.hashCache)
    // {
      [self.masqArtwork updateArtwork:act.coverArtContent.image];
      // HBLogWarn(@"Spotify has was different so updating!");
    // }
  }
  // @TODO might need another updater here cus it doesnt work too well
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

// ios 10? old devices? dunno
@interface SPTNowPlayingViewController : UIViewController
@property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(SPTNowPlayingContentView *)spt_nowPlayingCoverArtView;
-(SPTNowPlayingContentCell *)activeContentHost;
@end
%hook SPTNowPlayingViewController
%property (nonatomic, retain) MASQArtworkView * masqArtwork;
%new
-(void)addMasq {
  if (!self.masqArtwork)
  {
    self.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"Spotify" frameHost:[self spt_nowPlayingCoverArtView] imageHost:[self activeContentHost].coverArtContent];

    // only needed for especially difficult views that pretend to be at 0,0
    self.masqArtwork.centerHost = [self activeContentHost].contentUnitView;
    [self.view addSubview:self.masqArtwork];
  }
}

%new
-(SPTNowPlayingContentCell *)activeContentHost {
  SPTNowPlayingContentView * cell = [self spt_nowPlayingCoverArtView];
  return [cell cellAtRelativePage:0];
}
%end
