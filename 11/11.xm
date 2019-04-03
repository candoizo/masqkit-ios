#import "../src/MASQArtworkView.h"
#import "Interfaces.h"

//@TODO
// 11.2+ works pretty well
// 11.1.2
//  sometimes the thing is hidden when it shouldnt be :O

static NSString * const kControlCenterKey = @"CC";
static NSString * const kDashBoardKey = @"LS";

%ctor
{ // check that the kit has been loaded into the app we're hooking first
  if (!%c(MASQThemeManager))
  dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
}

%hook MediaControlsPanelViewController
-(id)headerView {
  MediaControlsHeaderView * orig = %orig;
  if ([orig artworkView] && !orig.masqArtwork)
  { //assign our view when the host is ready and there is none
    Class cc = %c(MediaControlsEndpointsViewController);
    Class ls = %c(SBDashBoardMediaControlsViewController);
    NSString * key;// assign the key based on where it's from
    if ([self.delegate isKindOfClass:cc]) key = kControlCenterKey;
    else if ([self.delegate isKindOfClass:ls]) key = kDashBoardKey;
    else return orig; //avoid mayhem from unexpected things

    if (key)
    { // load it in assuming we matched
      orig.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:key frameHost:orig.artworkView imageHost:orig.artworkView];
      orig.masqArtwork.userInteractionEnabled = !orig.masqArtwork.hidden; //only for sb so ppl can open app on tap
      [orig addSubview:orig.masqArtwork];
    }
  }
  return orig;
}

// wont have to worry about the ls much since it hides itself
-(void)_updateOnScreenForStyle:(long long)arg1 {
  %orig;
  // 0 expanded
  // 1 mini thing
  // 3 paused expanded?
  if (self.headerView.masqArtwork)
  {
    MASQArtworkView * artwork = self.headerView.masqArtwork;
    if ([artwork.identifier isEqualToString:kControlCenterKey])
    { // we only need to account for the different cc states on diff vers
      // artwork.hidden = [self onScreen];
      BOOL appPlaying = [%c(SBMediaController) sharedInstance].hasTrack;
      artwork.hidden = !appPlaying; //if app is playing, we are not hidden
      /*else */if ([%c(UIDevice) currentDevice].systemVersion.doubleValue < 11.2)
      {
        if (arg1 == 2 && appPlaying)
        artwork.hidden = NO;

        else if (arg1 == 0)
        artwork.hidden = YES;
        // before ios 11.2 its a bit different
        // 0 means closed
        // headerViewOnScreen is ios 1
        // headerViewOnScreen was removed
        // artwork.hidden = !(arg1 == 0 || self.headerView.headerViewOnScreen);

        // 0 means closed
        // 2 means open
        HBLogWarn(@"iOS 11.2 >, playing, style %d", (int)arg1);
        // if (arg1 == 2)
        // {
        //
        // }
        // else if ()
        // if (arg1 == 0)
        // {
        //   HBLogWarn(@"was zero");
        //   artwork.hidden = YES;
        //   if (appPlaying && arg1 != 0) artwork.hidden = NO;
        // }
        // else
        // {
        //   HBLogWarn(@"was something else");
        //   if (appPlaying) artwork.hidden = NO;
        // }
        // // artwork.hidden = arg1 == 0;
        // if (arg1 == 0 || self.headerView.headerViewOnScreen)
        // artwork.hidden = YES;
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

// since its sb we need to call this manually when they check
-(void)viewWillAppear:(BOOL)arg1 {
  %orig;
  if (self.headerView.masqArtwork)
  [self.headerView.masqArtwork updateTheme];
  // appstore extensions would not need to call this
}
%end

// hide other artwork stuff
%hook MediaControlsHeaderView
%property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(id)shadow {
  return nil;
}

-(id)artworkBackgroundView {
  return nil;
}

// we don't wan to break this one because we're hosting it
// it alive to handle all the layout methods pointed at it
-(id)artworkView {
  UIView * orig = %orig;
  orig.hidden = YES;
  return orig;
}
%end
