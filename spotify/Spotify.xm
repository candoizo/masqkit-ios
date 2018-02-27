#import "../src/MASQArtworkView.h"

@interface SPTNowPlayingCoverArtViewCell : UIView
@property (nonatomic) MASQArtworkView * masqArtwork;
@property (nonatomic) UIImageView * coverArtContent;
@property (nonatomic) UIImageView * placeholderImageView;
@end

%ctor {
  if (!%c(MASQArtworkView)) dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
  if (!%c(MASQArtworkView)) dlopen("/Library/TweakInject/MASQKit.dylib", RTLD_NOW);
  if (!%c(MASQArtworkView)) dlopen("/bootstrap/Library/SBInject/MASQKit.dylib", RTLD_NOW);
}

%hook SPTNowPlayingCoverArtViewCell
%property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(void)setCoverArtContent:(id)arg1 {
  %orig;
  if (!self.masqArtwork) {
    self.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"MP" frameHost:self imageHost:arg1];
    [self addSubview:self.masqArtwork];
  }
}

-(void)layoutSubviews {
  %orig;
  self.placeholderImageView.hidden = YES;
}
%end
