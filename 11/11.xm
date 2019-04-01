#import "../src/MASQArtworkView.h"
#import "Interfaces.h"

// All extensions need this to make sure the kit is loaded first
%ctor {
  if (!%c(MASQHousekeeper)) dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
}


%hook MediaControlsPanelViewController
-(id)headerView {
  MediaControlsHeaderView * orig = %orig;
  if ([orig artworkView] && !orig.masqArtwork)
  {

    Class cc = %c(MediaControlsEndpointsViewController);
    Class ls = %c(SBDashBoardMediaControlsViewController);
    // assign the key based on where it's from
    NSString * key; //here
    if ([self.delegate isKindOfClass:cc]) key = @"CC";
    else if ([self.delegate isKindOfClass:ls]) key = @"LS";

    if (key)
    { // load it in assuming we expected it
      orig.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:key frameHost:orig.artworkView imageHost:orig.artworkView];
      orig.masqArtwork.userInteractionEnabled = YES;
      [orig addSubview:orig.masqArtwork];
    }
    else HBLogError(@"No Theme Key? key:%@", key);
  }
  return orig;
}

-(void)_updateOnScreenForStyle:(long long)arg1 {
  %orig;
  // 0x0 expanded
  // 0x1 mini thing
  // 0x3 paused expanded?
  if (self.headerView.masqArtwork)
  {
    self.headerView.masqArtwork.hidden = !([%c(SBMediaController) sharedInstance].nowPlayingApplication);

    if ([%c(UIDevice) currentDevice].systemVersion.doubleValue < 11.2)
    {
      HBLogDebug(@"below v 11.2");
      self.headerView.masqArtwork.hidden = (arg1 == 0) || (arg1 == 3);
    }
    else
    {
          if ([self.headerView.masqArtwork.identifier isEqualToString:@"CC"])
          { // hiding of the cc modes
            if (arg1 == 0x3 || arg1 == 0x1)
            self.headerView.masqArtwork.hidden = YES;
            else if (arg1 == 0x0)
            self.headerView.masqArtwork.hidden = NO;
          }
    }
  }
}

-(void)viewWillAppear:(BOOL)arg1
{
  %orig;
  if (self.headerView.masqArtwork)
  [self.headerView.masqArtwork updateTheme];
}
%end

// hide artwork assets
%hook MediaControlsHeaderView
%property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(id)shadow {return nil;}

-(id)artworkBackgroundView {return nil;}

-(id)artworkView {
  UIView * orig = %orig;
  orig.hidden = YES;
  return orig;
}
%end
