#import "../src/MASQArtworkView.h"
#import "../src/MASQBlurredImageView.h"
#import "Interfaces.h"

/***

medialibraryd
mediaserverd
mediaremoted -- has the artowkr stuff!
***/

%ctor {
  if (!%c(MASQHousekeeper)) dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
}


%hook MediaControlsHeaderView
%property (nonatomic, retain) MASQArtworkView * masqArtwork;
//
-(id)shadow {return nil;}
%end

%hook MediaControlsPanelViewController

-(void)setMediaControlsPlayerState:(long long)arg1 {
  %orig;
  %log;
}

-(void)_updateOnScreenForStyle:(long long)arg1 {
  %orig;

}


-(void)viewWillAppear:(BOOL)arg1 { //cc present
  %orig;
  %log;
}

-(id)headerView {
  MediaControlsHeaderView * orig = %orig;
  if ([orig artworkView] && !orig.masqArtwork)
  {
    NSString * key;
    if ([self.delegate isKindOfClass:%c(MediaControlsEndpointsViewController))
    key = @"CC";
    else if ([self.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)])
    key = @"LS"
    if (key)
    {
      MASQArtworkView * m = [[%c(MASQArtworkView) alloc] initWithKey:key];
      [m registerHost:orig.artworkView];
      [m regist]
      //adds it to the MediaControlsHeaderView
      [orig addSubview:m];
    }
    else HBLogError(@"No Theme Key? key:%@", key);
  }
  return orig;
}


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
  // return orig;
// }
%end
