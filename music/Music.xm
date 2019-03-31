#import "../src/MASQArtworkView.h"
#import "Interfaces.h"

#define _c(s) NSClassFromString(s) // %_-
#define arrayOfClass(a, c) [a filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self isKindOfClass: %@", c]]

%hook MRNowPlayingPlayerClient
-(void)setNowPlayingArtwork:(NSData *)arg1 {
  %log;
  %orig;
}


-(void)setPlaybackState:(long long)arg1 {
  %log;
  %orig;
}
%end

// %hook Artwork
// %property (nonatomic, retain) MASQArtworkView * masqArtwork;
// -(void)layoutSubviews {
//   %orig;
//   if (!((Artwork *)self).masqArtwork) {
//     ((Artwork *)self).masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"MP" frameHost:self imageHost:[self imageSub]];
//     [((UIView *)self).superview addSubview:((Artwork *)self).masqArtwork];
//   }
//
//   if (((Artwork *)self).masqArtwork) {
//     ((Artwork *)self).masqArtwork.imageHost.hidden = YES;
//     [((Artwork *)self).masqArtwork updateFrame];
//
//     if (((Artwork *)self).subviews) for (UIView * v in ((Artwork *)self).subviews) {
//       v.hidden = ![v isKindOfClass:%c(MASQArtworkView)];
//     }
//   }
// }
//
// %new
// -(id)imageSub {
//   return arrayOfClass(((UIView *)self).subviews, _c(@"Music.ArtworkComponentImageView"))[0];
// }
//
// -(CALayer *)layer {return nil;} //remove shadow
// %end
//
// %hook MusicNowPlayingControlsViewController
// %property (nonatomic, retain) MASQArtworkView * masqArtwork;
// -(void)viewWillLayoutSubviews {
//   %orig;
//   if (!self.masqArtwork && [self artworkView] && self.view) {
//     self.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"MP" frameHost:[self artworkView] imageHost:[[self artworkView] imageSub]];
//     [self.view addSubview:self.masqArtwork];
//     self.masqArtwork.frame = CGRectMake(self.masqArtwork.frame.origin.x, self.masqArtwork.frame.origin.x, self.masqArtwork.bounds.size.width, self.masqArtwork.bounds.size.height);
//   }
// }
// %end
//
// %hook Mini
// %property (nonatomic, retain) MASQArtworkView * masqArtwork;
// -(Artwork *)artworkView {
//   Artwork * orig = %orig;
//   if (!((Mini *)self).masqArtwork && [orig imageSub] && ((Mini *)self).view) {
//     ((Mini *)self).masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"MP" frameHost:orig imageHost:[orig imageSub]];
//     [((Mini *)self).view addSubview:((Mini *)self).masqArtwork];
//   }
//   if (orig.subviews) for (UIView * v in orig.subviews) {
//     v.hidden = ![v isKindOfClass:%c(MASQArtworkView)];
//   }
//   return orig;
// }
// %end

%ctor {
  if (!%c(MASQHousekeeper)) dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
  // %init(Artwork = _c(@"Music.NowPlayingContentView"), Mini = _c(@"Music.MiniPlayerViewController"));
}
