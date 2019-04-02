#import "../src/MASQArtworkView.h"
#import "Interfaces.h"

//@TODO
// 11.2+ works pretty well
// 11.1.2
//  sometimes the thing is hidden when it shouldnt be :O

%ctor
{ // check that the kit has been loaded into the app we're hooking first
  if (!%c(MASQThemeManager))
  dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
}

%hook MediaControlsPanelViewController
-(id)headerView {
  MediaControlsHeaderView * orig = %orig;
  if ([orig artworkView] && !orig.masqArtwork)
  {
    Class cc = %c(MediaControlsEndpointsViewController);
    Class ls = %c(SBDashBoardMediaControlsViewController);
    NSString * key;// assign the key based on where it's from
    if ([self.delegate isKindOfClass:cc]) key = @"CC";
    else if ([self.delegate isKindOfClass:ls]) key = @"LS";
    else return orig; //avoid mayhem from unexpected things

    if (key)
    { // load it in assuming we matched
      orig.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:key frameHost:orig.artworkView imageHost:orig.artworkView];
      orig.masqArtwork.userInteractionEnabled = YES; //only for sb so ppl can open on tap
      [orig addSubview:orig.masqArtwork];
    }
  }
  return orig;
}

// we wont have to worry about the ls much since it hides itself
-(void)_updateOnScreenForStyle:(long long)arg1 {
  %orig;
  // 0x0 expanded
  // 0x1 mini thing
  // 0x3 paused expanded?
  if (self.headerView.masqArtwork)
  {
    // if (![%c(SBMediaController) sharedInstance].nowPlayingApplication)
    // {
    //   HBLogWarn(@"nothing playing, so we hide");
    //   self.headerView.masqArtwork.hidden = YES;
    // }
    /*else*/ if ([%c(UIDevice) currentDevice].systemVersion.doubleValue < 11.2)
    {
      // the arg1 == 3 seems to now work for 11.1.2

      // doesnt work because if you hit play before then it doesnt see it
      BOOL player = ([%c(SBMediaController) sharedInstance].nowPlayingApplication);
      if (!player && arg1 == 0) self.headerView.masqArtwork.hidden = YES;
      else
      self.headerView.masqArtwork.hidden = (arg1 == 0)/* || (arg1 == 3)*/;
    }
    else
    {
      if ([self.headerView.masqArtwork.identifier isEqualToString:@"CC"])
      { // tracking the cc module modes

        if (arg1 == 3 || arg1 == 1)
        self.headerView.masqArtwork.hidden = YES;
        else if (arg1 == 0)
        self.headerView.masqArtwork.hidden = NO;
      }
    }
  }
}

-(void)viewWillAppear:(BOOL)arg1 {
  %orig;
  if (self.headerView.masqArtwork)
  [self.headerView.masqArtwork updateTheme];
  // since its sb we call it manually when the user looks
  // in app extensions this is automatically handled
}
%end

// obscure artwork assets
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
