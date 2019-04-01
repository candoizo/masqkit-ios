#import "../src/MASQArtworkView.h"
#import "Interfaces.h"

#define _c(s) NSClassFromString(s) // %_-
#define arrayOfClass(a, c) [a filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self isKindOfClass: %@", c]]

@interface UIView (MASQ)
@property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(UIView *)imageSub;
-(void)addMasq;
@end

@interface ArtworkComponent : UIView

@end

%hook Artwork
%property (nonatomic, retain) MASQArtworkView * masqArtwork;
%new
-(void)addMasq {
  if (!((UIView*)self).masqArtwork)
  {
    UIView * se = self;
    UIView * is = [se imageSub];
    se.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"MP" frameHost:is imageHost:is];
    [se addSubview:se.masqArtwork];
  }
}


 %new
-(id)imageSub {
  UIView * i = arrayOfClass(((UIView *)self).subviews, _c(@"Music.ArtworkComponentImageView"))[0];
  return i;
}

-(id)subviews {
  NSArray * orig = %orig;
  for (UIView * v in orig)
  {
    v.hidden = ![v isKindOfClass:%c(MASQArtworkView)];
  }
  return orig;
}

-(CALayer *)layer {return nil;} // avoid shadow bakein

-(void)setVideoView:(BOOL)arg1 {
  UIView * se = self;
  // might need to check if imageSub has a width
  if (!se.masqArtwork && [se imageSub])
  {
    [se addMasq];
  }
  %orig;
}
%end

%ctor {
  if (!%c(MASQHousekeeper)) dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
  %init(Artwork = _c(@"Music.NowPlayingContentView"));
}
