#import "../src/MASQArtworkView.h"
#import "../src/MASQArtworkEffectView.h"
#import "Interfaces.h"

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

-(CALayer *)layer {return nil;} // avoid shadow

// doesnt seem to be called below 11.2
// or maybe i have to wait for the width idk
-(void)setVideoView:(BOOL)arg1 {
  Artwork * _self = self;

  if (!_self.masqArtwork && [_self imageSub])
  [_self addMasq];

  %orig;
}
%end

// @interface MNPCH : UIView
// @property (nonatomic, retain) MASQArtworkEffectView * masqBackground;
// @end
//

@interface MNPCH : UIViewController
-(BOOL)wantsMiniPlayer;


-(id)miniPlayerViewController;

-(id)nowPLayingViewController;

-(id)_collectionView;


-(NSArray *)mutableChildViewControllers;

-(
@end

%hook MNPCH
// %property (nonatomic, retain) MASQArtworkEffectView * masqBackground;
// // -(instancetype)initWithFrame:(CGRect)arg1 {
// //   MNPCH * orig = %orig;
// //   // MASQArtworkEffectView * bg = [[%c(MASQArtworkEffectView) alloc] initWithFrameHost:orig radiusHost:nil imageHost:nil];
// //   // bg.identifier = @"MP";
// //   orig.masqBackground = bg;
// //   return orig;
// //
// // }
//
// -(void)layoutSubviews {
//   %orig;
//   MNPCH * me = self;
//   MusicNowPlayingControlsViewController * vc = [%c(MusicNowPlayingControlsViewController) sharedInstance];
//   if (me && vc && !me.masqBackground) {
//     // MASQArtworkEffectView * bg = [[%c(MASQArtworkEffectView) alloc] initWithFrameHost:me radiusHost:self imageHost:vc.artworkView];
//     // bg.identifier = @"MP";
//     // me.masqBackground = bg;
//     // [me addSubview:bg];
//   }
//
// }
// %end
//
// MusicNowPlayingControlsViewController * inst;
// %hook MusicNowPlayingControlsViewController
// %property (nonatomic, retain) MASQArtworkEffectView * masqBackground;
// -(void)viewDidLayoutSubviews {
//   %orig;
//   MusicNowPlayingControlsViewController * me = self;
// //   if ([me artworkView] && !me.masqBackground) {
//     MASQArtworkEffectView * bg = [[%c(MASQArtworkEffectView) alloc] initWithFrameHost:me.view radiusHost:me.view imageHost:me.artworkView];
//     bg.identifier = @"MP";
//     me.masqBackground = bg;
// //     // [me.view addSubview:bg];
// //   }
// //
// }
//
// %new
// +(id)sharedInstance {
//   return inst ? inst : nil;
// }
//
// -(id)init {
//   if (self == %orig)
//   {
//     return inst = self;
//   }
//   return self;
// }

-(id)_collectionView {
  UIView * orig = %orig;
  orig.backgroundColor = [%c(UIColor) blackColor];
  return orig;

}

-(void)viewDidLayoutSubviews {
  %orig;


  [self _collectionView];
}

%end

%hook MTBC
-(void)_setSelectedViewControler:(UIViewController *)arg1
{
  %orig;
  if (arg1.view)
  {
    arg1.view.backgroundColor = [%c(UIColor) blackColor];

  }

}
%end

%ctor {
  if (!%c(MASQArtworkView))
  dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
  %init(Artwork = NSClassFromString(@"Music.NowPlayingContentView"), MNPCH = NSClassFromString(@"Music.NowPlayingControlsHeader"), MTBC = NSClassFromString(@"Music.TabBarController"));
}
