#import "../src/MASQArtworkView.h"
#import "Interfaces.h"

// @TODO
// 11.1.2 is problematic :(

#define _c(s) NSClassFromString(s) // %_-
#define arrayOfClass(a, c) [a filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self isKindOfClass: %@", c]]

@interface Artwork (MASQ)
@property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(UIView *)imageSub;
-(void)addMasq;
@end

%hook Artwork
%property (nonatomic, retain) MASQArtworkView * masqArtwork;
%new
-(void)addMasq {
  Artwork * _self = self;
  if (!_self.masqArtwork)
  {
    UIView * artImageView = [_self imageSub];
    _self.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"MP" frameHost:artImageView imageHost:artImageView];
    [_self addSubview:_self.masqArtwork];
  }
}

 %new
-(id)imageSub {
  Class artClass = NSClassFromString(@"Music.ArtworkComponentImageView");
  for (id v in ((Artwork *)self).subviews)
  {
    if ([v isKindOfClass:artClass]) return v;
  }
  return nil;
}

-(id)subviews {
  NSArray * orig = %orig;
  for (UIView * v in orig)
  { // there are quite persistent
    v.hidden = ![v isKindOfClass:%c(MASQArtworkView)];
  }
  return orig;
}

-(CALayer *)layer {return nil;} // avoid shadow bakein

// doesnt seem to be called below 11.2
// or maybe i have to wait for the width idk
-(void)setVideoView:(BOOL)arg1 {
  Artwork * _self = self;
  
  if (!_self.masqArtwork && [_self imageSub])
  [_self addMasq];

  %orig;
}
%end

%ctor {
  if (!%c(MASQArtworkView))
  dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
  %init(Artwork = NSClassFromString(@"Music.NowPlayingContentView"));
}
