#import "Interfaces.h"

static NSString * const kControlCenterKey = @"CC";
static NSString * const kDashBoardKey = @"LS";

%ctor
{ // check that the kit has been loaded into the hooked process
  if (!%c(MASQThemeManager))
  dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
}

%hook MediaControlsPanelViewController
// hooking the init and adding an observer to a new method would probably be a good idea
-(id)headerView {
  MediaControlsHeaderView * orig = %orig;
  if ([orig artworkView] && !orig.masqArtwork)
  { //assign our view when the host is ready and there is none
    Class cc = %c(MediaControlsEndpointsViewController);
    Class ls = %c(SBDashBoardMediaControlsViewController);
    NSString * key;// assign the key based on where it's from
    if ([self.delegate isKindOfClass:cc])
    key = kControlCenterKey;
    else if ([self.delegate isKindOfClass:ls])
    key = kDashBoardKey;
    else return orig; //avoid mayhem from unexpected things

    if (key && [orig artworkView])
    { // load it in assuming we matched
      orig.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:key frameHost:orig.artworkView imageHost:orig.artworkView];
      orig.masqArtwork.userInteractionEnabled = !orig.masqArtwork.hidden; //only for sb so ppl can open app on tap
      [orig addSubview:orig.masqArtwork];
    }
  }
  return orig;
}

-(void)_updateOnScreenForStyle:(long long)arg1 {
  %orig;
  if (self.headerView.masqArtwork)
  {
    MASQArtworkView * artwork = self.headerView.masqArtwork;
    if ([artwork.identifier isEqualToString:kControlCenterKey])
    { // we only need to account for the different cc states on diff vers
      // special ios 12 shit

      // artwork.hidden = [self onScreen];
      BOOL appPlaying = [%c(SBMediaController) sharedInstance].hasTrack;
      artwork.hidden = !appPlaying; //if app is playing, we are not hidden
      /*else */if ([%c(UIDevice) currentDevice].systemVersion.doubleValue < 11.2)
      {
        if (arg1 == 2 && appPlaying)
        artwork.hidden = NO;

        else if (arg1 == 0)
        artwork.hidden = YES;
      }
      else if (appPlaying)
      { // a higher version, and we have a track
        // 0 means open, 1 = 3 mean transition / closing
        if (arg1 == 3 || arg1 == 1)
        artwork.hidden = YES;
        else if (arg1 == 0)
        artwork.hidden = NO;
      }
    }
  }
}

// // since they can view these without having springboard as the foreground app
-(void)viewWillAppear:(BOOL)arg1 {
  %orig;
  if (self.headerView.masqArtwork)
  [self.headerView.masqArtwork updateTheme];
  // appstore extensions would not need to call this
}
%end

// ios 12.2-4? .4 fosho
%hook MRPlatterViewController
-(id)nowPlayingHeaderView {
  MediaControlsHeaderView * orig = %orig;
  if ([orig artworkView] && !orig.masqArtwork)
  { //assign our view when the host is ready and there is none
    Class cc = %c(MediaControlsEndpointsViewController);
    Class ls = %c(SBDashBoardMediaControlsViewController);
    NSString * key;// assign the key based on where it's from
    if ([self.delegate isKindOfClass:cc])
    key = kControlCenterKey;
    else if ([self.delegate isKindOfClass:ls])
    key = kDashBoardKey;
    else return orig; //avoid mayhem from unexpected things

    if (key && [orig artworkView])
    { // load it in assuming we matched
      orig.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:key frameHost:orig.artworkView imageHost:orig.artworkView];
      orig.masqArtwork.userInteractionEnabled = !orig.masqArtwork.hidden; //only for sb so ppl can open app on tap
      [orig addSubview:orig.masqArtwork];
    }
  }
  return orig;
}

-(void)_updateOnScreenForStyle:(long long)arg1 {
  %orig;
  if (self.nowPlayingHeaderView.masqArtwork)
  {
    MASQArtworkView * artwork = self.nowPlayingHeaderView.masqArtwork;
    if ([artwork.identifier isEqualToString:kControlCenterKey])
    { // we only need to account for the different cc states on diff vers
      // special ios 12 shit

      // artwork.hidden = [self onScreen];
      BOOL appPlaying = [%c(SBMediaController) sharedInstance].hasTrack;
      artwork.hidden = !appPlaying; //if app is playing, we are not hidden
      /*else */if ([%c(UIDevice) currentDevice].systemVersion.doubleValue >= 12.2)
      {
        // style = 0 when open, 1 in small mode
        if (self.nowPlayingHeaderView.style == 0 && appPlaying)
        artwork.hidden = NO;
        else artwork.hidden = YES;
      }
    }
  }
}

// // since they can view these without having springboard as the foreground app
-(void)viewWillAppear:(BOOL)arg1 {
  %orig;

  if (self.nowPlayingHeaderView.masqArtwork)
  [self.nowPlayingHeaderView.masqArtwork updateTheme];
  // appstore extensions would not need to call this
}
%end

// hide other artwork stuff
%hook MediaControlsHeaderView
%property (nonatomic, retain) MASQArtworkView * masqArtwork;

-(id)artworkView {
  // we don't wan to break this one
  UIView * orig = %orig;
  orig.hidden = YES;
  return orig;
}

-(id)shadow {
  return nil;
}

//ios 11
-(id)artworkBackgroundView {
  return nil;
}

// ios 12
- (id)artworkBackground {
    return nil;
}
%end
