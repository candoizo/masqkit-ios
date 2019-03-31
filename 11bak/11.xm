#import "../src/MASQArtworkView.h"
#import "../src/MASQBlurredImageView.h"
#import "Interfaces.h"

%ctor {
  if (!%c(MASQHousekeeper)) dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
}

%hook MediaControlsPanelViewController
%property (nonatomic, assign) float trueWidth;
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
  %orig;
  if (self.masqBackground) {
    self.masqBackground.hidden = arg1 == 0; //if not playing
    if (!self.masqBackground.image) [self.masqBackground loadArtwork];
  }
}


-(void)viewWillAppear:(BOOL)arg1 { //cc present

  if (self.masqBackground) {
    [self.masqBackground loadArtwork];

    if ([self.masqBackground.styleKey hasPrefix:@"CC"])  {
      // ios 11-11.1.12
      if ([self respondsToSelector:@selector(mediaControlsPlayerState)])  self.masqBackground.hidden = (self.mediaControlsPlayerState == 0);
      // higher ios doesnt have this anymore
      else self.masqBackground.hidden = NO;//(self.style == 0); //@TODO FIX THIS JEEZ well no backgrounds work in general atm rip
    }
    HBLogDebug(@"fcurrent style is %d", self.style);


    [self.masqBackground updateEffectWithKey];
  }
  if (!self.masqBackground && !self.backgroundView) { //lockscreen does not set it for some reason
    CGRect r = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.trueWidth, self.view.bounds.size.height);
    [self.view insertSubview:self.masqBackground = [[%c(MASQBlurredImageView) alloc] initWithFrame:r layer:nil] atIndex:0];
    self.masqBackground.styleKey = @"LSStyle";
    self.masqBackground.hidden = YES;
    self.masqBackground.clipsToBounds = YES;
    [self.masqBackground _setContinuousCornerRadius:12];
    [self.masqBackground updateEffectWithKey];
  }
  %orig;
}

-(id)headerView {
  MediaControlsHeaderView * orig = %orig;
  self.trueWidth = self.trueWidth < self.view.superview.superview.bounds.size.width ? self.view.superview.superview.bounds.size.width : self.trueWidth;
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
  if ([%c(UIDevice) currentDevice].systemVersion.floatValue <= 11.2) {
    HBLogWarn(@"arg1 %d", (int)arg1);
    self.headerView.masqArtwork.hidden = (arg1 != 0);
  }
  else if (self.headerView.masqArtwork)
  self.headerView.masqArtwork.hidden = ((arg1 == 0) || self.headerView.masqArtwork.disabled); //if not expanded / disbled
}

-(void)viewDidLayoutSubviews {
  %orig;
  if (!self.backgroundView && self.masqBackground) {
    CGRect propose = CGRectMake(self.masqBackground.bounds.origin.x, self.masqBackground.bounds.origin.y, self.trueWidth, self.masqBackground.bounds.size.height);
    if (!CGRectEqualToRect(self.masqBackground.bounds, propose)) self.masqBackground.bounds = propose; //jumpy without this if
    self.masqBackground.center = CGPointMake(self.headerView.center.x,self.masqBackground.center.y);
  }
}
%end

%hook MediaControlsHeaderView
%property (nonatomic, retain) MASQArtworkView * masqArtwork;
-(id)shadow {return nil;}
%end
