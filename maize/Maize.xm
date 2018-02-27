#import "../src/MASQArtworkView.h"
#import "dlfcn.h"

@interface MZEMediaMetaDataView : UIView
@property (nonatomic, retain) MASQArtworkView * masqArtwork;
@property () BOOL expanded;
@end

@interface MZEMediaArtworkView : UIView
@property (nonatomic) UIImageView * imageView;
@end

%ctor {
    dlopen("/Library/Maize/Bundles/com.ioscreatix.maize.MediaModule.bundle/MediaModule", RTLD_NOW);
    if (!%c(MASQArtworkView)) dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
}

%hook MZEMediaMetaDataView
%property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(MZEMediaArtworkView *)artworkView {
  MZEMediaArtworkView * orig = %orig;
    if (!self.masqArtwork) {
      self.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"CC" frameHost:orig imageHost:orig.imageView];
      [self addSubview:self.masqArtwork];
    }
  return orig;
}

-(void)updateFrame {
  %orig;
  if (self.masqArtwork) {
    self.masqArtwork.hidden = !self.expanded;
    for (UIView * v in self.masqArtwork.frameHost.subviews) {v.hidden = YES;} //workaround reshowing background
  }
}
%end
