#import "../src/MASQArtworkView.h"
#import "../src/MASQBlurredImageView.h"
#import "Interfaces.h"

%ctor {
  if (!%c(MASQHousekeeper)) dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
}

//LS
%hook SBDashBoardMediaControlsViewController
%property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(id)initWithMediaControlsViewController:(MPULockScreenMediaControlsViewController *)arg1 {
   if (self == %orig)  {
     if (!self.masqArtwork && [arg1 artworkView]) {
       self.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"LS" frameHost:[arg1 artworkView] imageHost:[[arg1 artworkView] valueForKey:@"_artworkImageView"]];
       [self.view addSubview:self.masqArtwork];
     }

     if (!arg1.masqBackground) {
       arg1.masqBackground = [[%c(MASQBlurredImageView) alloc] initWithFrame:self.view.frame layer:nil];
       arg1.masqBackground.styleKey = @"LSStyle";
       [arg1.masqBackground updateEffectWithKey];
       [self.view insertSubview:arg1.masqBackground atIndex:0];
     }
  }
  return self;
}
%end

%hook MPULockScreenMediaControlsViewController
%property (nonatomic, retain) MASQBlurredImageView * masqBackground;
-(void)lockScreenControlsView:(id)arg1 nowPlayingArtworkDidChange:(id)arg2 {
  %orig;
  if (self.masqBackground) [self.masqBackground loadArtwork];
}

-(void)viewWillAppear:(BOOL)arg1 {
  %orig;
  if (self.masqBackground) [self.masqBackground updateEffectWithKey];
}
%end

//CC
%hook MPUControlCenterMediaControlsView
%property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(id)initWithFrame:(CGRect)arg1 {
  self = %orig;
  if (self && !self.masqArtwork) {
     self.masqArtwork = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"CC" frameHost:[self artworkView] imageHost:[[self artworkView] valueForKey:@"_artworkImageView"]];
     [self addSubview:self.masqArtwork];
     }
   return self;
}

-(void)setDisplayMode:(unsigned long long)arg1 {
  %orig;
  if (self.masqArtwork) self.masqArtwork.hidden = (self.displayMode != 0 || self.masqArtwork.disabled);
}
%end

%hook CCUIControlCenterPageContainerViewController
-(id)_pagePlatterView {
   id orig = %orig;
   if([self.contentViewController isKindOfClass:%c(MPUControlCenterMediaControlsViewController)]) {
     MPUControlCenterMediaControlsViewController * music = ((MPUControlCenterMediaControlsViewController *)self.contentViewController);
      if (!music.masqBackground) {
        music.masqBackground = [[%c(MASQBlurredImageView) alloc] initWithFrame:self.view.frame layer:nil];
        music.masqBackground.layer.masksToBounds = YES;
        music.masqBackground.layer.cornerRadius = 15;
        music.masqBackground.styleKey = @"CCStyle";
        [music.masqBackground updateEffectWithKey];
        [self.view insertSubview:music.masqBackground atIndex:2];
      }
   }
   return orig;
}
%end

%hook MPUControlCenterMediaControlsViewController
%property (nonatomic, retain) MASQBlurredImageView * masqBackground;
-(void)controlCenterWillPresent {
  %orig;
  if (self.masqBackground) {
    [self.masqBackground loadArtwork];
    [self.masqBackground updateEffectWithKey];
  }
}
%end
