#import "../src/MASQArtworkView.h"
#import "../src/MASQBlurredImageView.h"
#import "Interfaces.h"

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
// }

  // self.trueWidth = self.trueWidth < self.view.superview.superview.bounds.size.width ? self.view.superview.superview.bounds.size.width : self.trueWidth;
  //
  //
  // orig.artworkBackgroundView.hidden = YES;
  //   if (orig.artworkView && !orig.masqArtwork && [self.delegate isKindOfClass:%c(MediaControlsEndpointsViewController)]) {
  //     orig.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"CC" frameHost:orig.artworkView imageHost:orig.artworkView];
  //     [orig addSubview:orig.masqArtwork];
  //   }
  //   else if (orig.artworkView && !orig.masqArtwork && [self.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)]) {
  //     orig.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"LS" frameHost:orig.artworkView imageHost:orig.artworkView];
  //     [orig addSubview:orig.masqArtwork];
  //   }
  return orig;
}


-(void)setMediaControlsPlayerState:(long long)arg1 {
  %orig;
  %log;
}

-(void)_updateOnScreenForStyle:(long long)arg1 {
  %orig;
  // 0x0 expanded
  // 0x1 mini thing
  // 0x3 paused expanded?
  if (self.headerView.masqArtwork)
  {
    if (arg1 == 0x3 || arg1 == 0x1) {
      self.headerView.masqArtwork.hidden = YES;
    }
    else if (arg1 == 0x0)
      self.headerView.masqArtwork.hidden = NO;
    else {
      HBLogWarn(@"unknown case %d", (int)arg1);
    }
  }
  // 0x1 mini thing visible
}


-(void)viewWillAppear:(BOOL)arg1 { //cc present
  %orig;
  %log;
}
%end

%hook MediaControlsHeaderView
%property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(id)shadow {return nil;}
%end
