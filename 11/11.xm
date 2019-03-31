#import "../src/MASQArtworkView.h"
#import "../src/MASQBlurredImageView.h"
#import "Interfaces.h"

// All extensions need this to load the kit in
%ctor {
  if (!%c(MASQHousekeeper)) dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
}

%hook MediaControlsPanelViewController
-(id)headerView {
  MediaControlsHeaderView * orig = %orig;
  if ([orig artworkView] && !orig.masqArtwork)
  {
    NSString * key;
    if ([self.delegate isKindOfClass:%c(MediaControlsEndpointsViewController)])
    key = @"CC";
    else if ([self.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)])
    key = @"LS";
    if (key)
    {
      MASQArtworkView * m = [[%c(MASQArtworkView) alloc] initWithThemeKey:key frameHost:orig.artworkView imageHost:orig.artworkView];
      orig.masqArtwork = m;
      [orig addSubview:m];
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
    if ([self.headerView.masqArtwork.identifier isEqualToString:@"CC"])
    { // tighter hiding of the cc
      if (arg1 == 0x3 || arg1 == 0x1) {
        self.headerView.masqArtwork.hidden = YES;
      }
      else if (arg1 == 0x0)
        self.headerView.masqArtwork.hidden = NO;
      else {
        HBLogWarn(@"unknown case %d", (int)arg1);
      }
    }
  }
  // 0x1 mini thing visible
}

-(void)viewWillAppear:(BOOL)arg1 { //cc present
  %orig;
  if (self.headerView.masqArtwork)
  [self.headerView.masqArtwork updateTheme];
}

// -(void)setMediaControlsPlayerState:(long long)arg1 {
//   %orig;
//   %log;
// }
//
%end

%hook MediaControlsHeaderView
%property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(id)shadow {return nil;}

-(id)artworkBackgroundView {return nil;}

// -(void)layoutSubviews {
//   %orig;
//   self.artworkView.hidden = !self.masqArtwork.disabled;
// }

-(id)artworkView {
  UIView * orig = %orig;
  orig.hidden = self.masqArtwork.currentTheme ? YES : NO;
  return orig;
}
%end
