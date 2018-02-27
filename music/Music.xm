#import "../src/MASQArtworkView.h"

@interface Artwork : UIView
@property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(id)imageSub;
@end

%hook Artwork
%property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(void)layoutSubviews {
  %orig;
  if (!((Artwork *)self).masqArtwork) {
    ((Artwork *)self).masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"MP" frameHost:self imageHost:[self imageSub]];
    [((UIView *)self).superview addSubview:((Artwork *)self).masqArtwork];
  }

  if (((Artwork *)self).masqArtwork) {
    ((Artwork *)self).masqArtwork.imageHost.hidden = YES;
  }
  if (((Artwork *)self).masqArtwork) [((Artwork *)self).masqArtwork updateFrame];
}

#define arrayOfClass(a, c) [a filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self isKindOfClass: %@", c]]
%new
-(id)imageSub {
  return arrayOfClass(((UIView *)self).subviews, NSClassFromString(@"Music.ArtworkComponentImageView"))[0];
}
%end

%ctor {
  if (!%c(MASQArtworkView)) dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
  if (!%c(MASQArtworkView)) dlopen("/Library/TweakInject/MASQKit.dylib", RTLD_NOW);
  if (!%c(MASQArtworkView)) dlopen("/bootstrap/Library/SBInject/MASQKit.dylib", RTLD_NOW);
  %init(Artwork = objc_getClass("Music.NowPlayingContentView"));
}
