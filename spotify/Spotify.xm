#import "../src/MASQArtworkView.h"

@interface SPTNowPlayingCoverArtViewCell : UIView
@property (nonatomic) UIView * delegate;
@property (nonatomic) MASQArtworkView * masqArtwork;
@property (nonatomic) UIImageView * coverArtContent;
@property (nonatomic) UIImageView * placeholderImageView;
@end

%ctor {
  if (!%c(MASQHousekeeper)) dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
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

-(void)setFrame:(CGRect)arg1 {
  %orig(CGRectMake(arg1.origin.x, arg1.origin.y, arg1.size.width*0.825, arg1.size.height*0.825));
}

-(void)layoutSubviews {
  %orig;
  self.placeholderImageView.hidden = YES;
  if (self.masqArtwork) {
    self.masqArtwork.bounds = CGRectMake(0, 0, self.masqArtwork.bounds.size.width, self.masqArtwork.bounds.size.height);
    self.masqArtwork.center = [self convertPoint:self.superview.center toView:self.masqArtwork]; //YAY
  }
}
%end
