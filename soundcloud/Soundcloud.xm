#import "../src/MASQArtworkView.h"

//ps the root vc has a dope mini player

// @interface PlayerArtworkView
// @property () UIImageView * artworkImageView;
// @end
//
// @interface TrackPlayerViewModel
// @property () PlayerArtworkView * artworkAnimationView;
// @end
//
// @interface TrackPlayerViewController : UIViewController
// @property () TrackPlayerViewModel * trackViewModel;
// @property () MASQArtworkView * masqArtwork;
// @end
//
// %hook TrackPlayerViewController
// %property (nonatomic, retain) MASQArtworkView * masqArtwork;
// -(void)presentViewForPlayState:(int)arg1 animated:(BOOL)arg2 {
//   %orig;
//   if (arg1 == 0 && !arg2) {
//       %log;
//        if (self.masqArtwork) {
//          [self.masqArtwork updateArtwork:nil];
//          [self.masqArtwork updateFrame];
//        }
//   }
//   if (self.masqArtwork) [self.masqArtwork updateArtwork:nil];
//
//   BOOL masq = NO;
//   for (id v in self.view.subviews) {
//     if ([v isMemberOfClass:%c(MASQArtworkView)]) masq = YES;
//   }
//
//      if (!masq && self.trackViewModel.artworkAnimationView.artworkImageView && self.trackViewModel.artworkAnimationView.artworkImageView.image) {
//        self.masqArtwork = [[%c(MASQArtworkView) alloc] initWithOrig:self.trackViewModel.artworkAnimationView.artworkImageView themeKey:@"MP"];
//        [self.view addSubview:self.masqArtwork];
//      }
// }
// %end

@interface PlayerArtworkView : UIView
@property (nonatomic) MASQArtworkView * masqArtwork;
@property (nonatomic) UIImageView * artworkImageView;
@property (nonatomic) UIView * clipView;
@end

%ctor {
  if (!%c(MASQArtworkView)) dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
  if (!%c(MASQArtworkView)) dlopen("/Library/TweakInject/MASQKit.dylib", RTLD_NOW);
  if (!%c(MASQArtworkView)) dlopen("/bootstrap/Library/SBInject/MASQKit.dylib", RTLD_NOW);
}

%hook PlayerArtworkView
%property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(void)setArtworkImageView:(id)arg1 {
  %orig;
  if (!self.masqArtwork) {
    self.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"MP" frameHost:self.clipView imageHost:arg1];
    [self addSubview:self.masqArtwork];
  }
}
%end
