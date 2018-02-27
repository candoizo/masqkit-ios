#import "../src/MASQArtworkView.h"
#import "../src/MASQBlurredImageView.h"
#import "MediaRemote/MediaRemote.h"

@interface MediaControlsHeaderView : UIView
@property (nonatomic, retain) MASQArtworkView * masqArtwork;
@property (nonatomic,retain) UIImageView * artworkView;
@property () UIView * artworkBackgroundView;
@end

@interface MediaControlsPanelViewController : UIViewController
@property (nonatomic) MediaControlsHeaderView * headerView;
@property (nonatomic) id delegate;
@property (assign,nonatomic) int mediaControlsPlayerState;
@property (nonatomic, retain) MASQBlurredImageView * masqBackground;
@end

%ctor {
  if (!%c(MASQArtworkView)) dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
  if (!%c(MASQArtworkView)) dlopen("/Library/TweakInject/MASQKit.dylib", RTLD_NOW);
  if (!%c(MASQArtworkView)) dlopen("/bootstrap/Library/SBInject/MASQKit.dylib", RTLD_NOW);
}

%hook MediaControlsPanelViewController
%property (nonatomic, retain) MASQBlurredImageView * masqBackground;

-(void)setBackgroundView:(UIView *)arg1 {
  %orig;
  if (!self.masqBackground) {
    CALayer * l = [arg1 valueForKeyPath:@"_backdropView.layer"];
    [arg1 addSubview:self.masqBackground = [[%c(MASQBlurredImageView) alloc] initWithFrame:arg1.bounds layer:l]];
    self.masqBackground.styleKey = @"CCStyle";
    self.masqBackground.hidden = YES;
    [self.masqBackground updateEffectWithKey];
  }
}

-(void)setMediaControlsPlayerState:(long long)arg1 {
  %log;
  %orig;
  if (self.masqBackground) {
  self.masqBackground.hidden = arg1 == 0; //if not playing
    if (!self.masqBackground.image) { //loading, need to prime with image
      MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
      NSDictionary *dict = (__bridge NSDictionary *)(information);
        if (dict[@"kMRMediaRemoteNowPlayingInfoArtworkData"]) {
          NSData *artworkData = dict[@"kMRMediaRemoteNowPlayingInfoArtworkData"];
          if (self.masqBackground) self.masqBackground.image = [UIImage imageWithData:artworkData];
        }
      });
    }
  }
  /*
  if (else if ?) no self.backgroundView > [self setBackgroundView:masqBackground] for ls !
  */
}

-(void)viewWillAppear:(BOOL)arg1 { //cc present
  if (self.masqBackground) {
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
    NSDictionary *dict = (__bridge NSDictionary *)(information);
      if (dict[@"kMRMediaRemoteNowPlayingInfoArtworkData"]) {
        NSData *artworkData = dict[@"kMRMediaRemoteNowPlayingInfoArtworkData"];
        if (self.masqBackground) self.masqBackground.image = [UIImage imageWithData:artworkData];
      }
    });
    self.masqBackground.hidden = self.mediaControlsPlayerState == 0;
    [self.masqBackground updateEffectWithKey];
  }
  %orig;
}

-(void)_mediaControlsPanelViewControllerReceivedInteraction:(id)arg1 { //not workingggg
  %log;
  %orig;
    if (self.masqBackground && self.headerView.masqArtwork.artworkImageView.image) self.masqBackground.image = self.headerView.masqArtwork.artworkImageView.image;
}

-(id)headerView {
  MediaControlsHeaderView * orig = %orig;
  orig.artworkBackgroundView.hidden = YES;
    if (orig.artworkView && !orig.masqArtwork && [self.delegate isKindOfClass:%c(MediaControlsEndpointsViewController)]) {
      orig.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"CC" frameHost:orig.artworkView imageHost:orig.artworkView];
      [orig addSubview:orig.masqArtwork];
    }
    else if (orig.artworkView && !orig.masqArtwork && [self.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)]) {
      orig.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"LS" frameHost:orig.artworkView imageHost:orig.artworkView];
      [orig addSubview:orig.masqArtwork];
    }
  return orig;
}

-(void)_updateOnScreenForStyle:(long long)arg1 {
  %orig;
  if (self.headerView.masqArtwork) self.headerView.masqArtwork.hidden = arg1 == 0; //if not expanded
}
%end

%hook MediaControlsHeaderView
%property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(id)shadow {return nil;}
%end
