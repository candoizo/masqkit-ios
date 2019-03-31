#import "../src/MASQArtworkView.h"

@interface SPTNowPlayingCoverArtViewCell : UIView
@property (nonatomic) UIView * delegate;
// @property (nonatomic) MASQArtworkView * masqArtwork;
@property (nonatomic) UIImageView * coverArtContent;
@property (nonatomic) UIImageView * placeholderImageView;
@property (nonatomic, assign) BOOL hasMasq;
@end

%ctor {
  if (!%c(MASQHousekeeper)) dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
}

%hook SPTNowPlayingCoverArtImageContentView

%end

%hook SPTNowPlayingCoverArtViewCell
// %property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(void)setCoverArtContent:(id)arg1 {
  %orig;
  if (!self.hasMasq) {//(!self.masqArtwork) {
    // self.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"MP" frameHost:self imageHost:arg1];
    MASQArtworkView * masq = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"MP" frameHost:self imageHost:arg1];
    [self addSubview:masq];
    self.hasMasq = YES;
    // [self addSubview:self.masqArtwork];
  }
}

-(void)setFrame:(CGRect)arg1 {
  %orig(CGRectMake(arg1.origin.x, arg1.origin.y, arg1.size.width*0.825, arg1.size.height*0.825));
}

// -(void)layoutSubviews {
//   %orig;
//   self.placeholderImageView.hidden = YES;
//   if (self.masqArtwork) {
//     self.masqArtwork.bounds = CGRectMake(0, 0, self.masqArtwork.bounds.size.width, self.masqArtwork.bounds.size.height);
//     self.masqArtwork.center = [self convertPoint:self.superview.center toView:self.masqArtwork]; //YAY
//   }
// }

%new
-(void)setHasMasq:(BOOL)arg1 {
    objc_setAssociatedObject(self, @selector(hasMasq), @(arg1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
- (BOOL)hasMasq {
    return [objc_getAssociatedObject(self, @selector(hasMasq)) boolValue];
}
%end

@interface SPTVideoSurfaceImpl : UIView
@property (nonatomic, retain) MASQArtworkView * masqArtwork;
@property (nonatomic, assign) BOOL hasMasq;
@end

// %hook SPTVideoSurfaceImpl
// -(void)refreshVideoRect {
//   %orig;
//   %log;
//   self.transform = CGAffineTransformMakeScale(0.7, 0.7);
//   // if (![self masqArtwork]) {
//     // self.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"MP" frameHost:self imageHost:self];
//     // [self addSubview:self.masqArtwork];
//   // }
//   if (!self.hasMasq) {
//     HBLogDebug(@"no masq!");
//     MASQArtworkView * masq = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"MP" frameHost:self imageHost:self];
//     [self.superview addSubview:masq];
//     self.hasMasq = YES;
//   }
// }
//
// %new
// -(void)setMasqArtwork:(id)arg1 {
//     HBLogDebug(@" setting %@", arg1);
//     objc_setAssociatedObject(self, @selector(masqArtwork), arg1, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//     HBLogDebug(@"set!");
// }
//
// %new
// -(id)masqArtwork {
//   return objc_getAssociatedObject(self, @selector(masqArtwork));
// }
//
// %new
// -(void)setHasMasq:(BOOL)arg1 {
//     objc_setAssociatedObject(self, @selector(hasMasq), @(arg1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
// }
//
// %new
// - (BOOL)hasMasq {
//     return [objc_getAssociatedObject(self, @selector(hasMasq)) boolValue];
// }
// %end

// %hook SPTVideoDisplayView
//
// %end
//
// %hook SPTNowPlayingCoverArtImageContentView
//
// %end
//
// %hook SPTNowPlayingScrollViewController
// -(id)nowPlayingViewController {
//   id orig = %orig;
//   HBLogDebug(@"%@", ((UIView*)orig).class);
//   return orig;
// }
// %end
