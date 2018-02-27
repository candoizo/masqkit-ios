#import "dlfcn.h"
#import "../src/MASQArtworkView.h"

@interface MPULockScreenMediaControlsViewController : UIViewController
-(id)artworkView;
@end

@interface SBDashBoardMediaControlsViewController : UIViewController
@property (nonatomic, retain) MASQArtworkView * masqArtwork;

@end

@interface MPUControlCenterMediaControlsView : UIView
@property (nonatomic) int displayMode;
@property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(id)artworkView;
@end

%ctor {
  if (!%c(MASQArtworkView)) dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
}

//LS
%hook SBDashBoardMediaControlsViewController
%property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(id)initWithMediaControlsViewController:(MPULockScreenMediaControlsViewController *)arg1 {
   self = %orig;
   if (self && !self.masqArtwork) {
      self.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"LS" frameHost:[arg1 artworkView] imageHost:[[arg1 artworkView] valueForKey:@"_artworkImageView"]];
      [self.view addSubview:self.masqArtwork];
      }
   return self;
}
%end

//CC
%hook MPUControlCenterMediaControlsView
%property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(id)initWithFrame:(CGRect)arg1 {
  self = %orig;
  if (self && !self.masqArtwork) {
     self.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"CC" frameHost:[self artworkView] imageHost:[[self artworkView] valueForKey:@"_artworkImageView"]];
     [self addSubview:self.masqArtwork];
     }
   return self;
}

-(void)layoutSubviews {
  %orig;
  if (self.masqArtwork) self.masqArtwork.hidden = self.displayMode == 0;
}
%end
