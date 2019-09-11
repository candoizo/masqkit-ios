#import "../src/MASQArtworkView.h"

@interface PlayerArtworkView : UIView
@property (nonatomic) MASQArtworkView * masqArtwork;
@property (nonatomic) UIImageView * artworkImageView;
@property (nonatomic) UIView * clipView;
@end

%ctor {
  if (!%c(MASQHousekeeper)) dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
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
