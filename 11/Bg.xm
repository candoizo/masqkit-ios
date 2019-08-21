#import "Interfaces.h"


// ios 11-12.1.2
%hook MediaControlsPanelViewController
%property (nonatomic, assign) float trueWidth;
%property (nonatomic, retain) MASQArtworkBlurView * masqBackground;

-(void)setBackgroundView:(UIView *)arg1
{
  %orig;

  if (!self.masqBackground)
  { // ios 11 - 12.4 control center
    [arg1 addSubview:self.masqBackground = [[%c(MASQArtworkBlurView) alloc] initWithFrame:arg1.bounds]];
    self.masqBackground.imageHost = self.headerView.artworkView;
    self.masqBackground.identifier = @"CC";

    // self.masqBackground.hidden = YES;


    // [self.masqBackground updateEffectWithKey];
    // [self.masqBackground updateArtwork:nil];
  }
}

//need to investigate why it doesnt update based on my notification :/
// -(void)_updateHeaderUI { // ios 12.2
//   %orig;
//   // if (self._continuousCornerRadius && self.style == 1)
//   // [self.masqBackground _setContinuousCornerRadius:self._continuousCornerRadius/2];
//   [self.masqBackground updateArtwork:nil];
//
//   NSString * key = [NSString stringWithFormat:@"%@.style", self.masqBackground.identifier];
//   int style = [[%c(MASQThemeManager) prefs] integerForKey:key];
//   self.masqBackground.alpha = !(style == 0) || [%c(SBMediaController) sharedInstance].hasTrack;
//   self.masqBackground.hidden = style == 0 || ![%c(SBMediaController) sharedInstance].hasTrack;
//
//   // self.masqBackground.alpha = [%c(SBMediaController) sharedInstance].hasTrack;
//   // self.masqBackground.hidden = ![%c(SBMediaController) sharedInstance].hasTrack;
//
//   // if (self.masqBackground)
//   // [self.masqBackground updateArtwork];
//   //
//   //   [self.masqBackground updateEffectWithKey];
// }


// -(void)setMediaControlsPlayerState:(long long)arg1 {
//   %orig;
//   if (self.view)
//   {
//     HBLogDebug(@"Hidden: %d | Alpha: %d", self.masqBackground.hidden, self.masqBackground.alpha);
//     [self.masqBackground _setContinuousCornerRadius:self.view.layer.maskedCorners*0.99];
//   }
//   // if (self.masqBackground) { // needed for 11 - 12.1.2
//     // self.masqBackground.hidden = arg1 == 0; //if not playing
//     // if (!self.masqBackground.image) [self.masqBackground updateArtwork:nil];
//   }
// }

-(void)_updateOnScreenForStyle:(long long)arg1 {
  %orig;


  // NSString * key = [NSString stringWithFormat:@"%@.style", self.masqBackground.identifier];
  // int style = [[%c(MASQThemeManager) prefs] integerForKey:key];
  // self.masqBackground.alpha = !(style == 0) || [%c(SBMediaController) sharedInstance].hasTrack;
  // self.masqBackground.hidden = style == 0 || ![%c(SBMediaController) sharedInstance].hasTrack;

}
//
//

-(void)viewWillAppear:(BOOL)arg1 { //cc present
  if (self.masqBackground) {
    if (self.view)
    { // cc rounded corner
      [self.masqBackground _setContinuousCornerRadius:self.view.layer.maskedCorners*0.99];
    }

    if ([self.masqBackground.identifier hasPrefix:@"CC"])
    {
      // ios 11-11.1.12
      if ([self respondsToSelector:@selector(mediaControlsPlayerState)])
      self.masqBackground.hidden = (self.mediaControlsPlayerState == 0);
      // higher ios doesnt have this anymore
      else self.masqBackground.hidden = NO;

      //(self.style == 0); //@TODO FIX THIS JEEZ well no backgrounds work in general atm rip


      // // trying to hide cc when disabled
      // NSString * key = [NSString stringWithFormat:@"%@.style", self.masqBackground.identifier];
      // int style = [[%c(MASQThemeManager) prefs] integerForKey:key];
      // self.masqBackground.alpha = !(style == 0);
      // self.masqBackground.hidden = style == 0;

    }

    [self.masqBackground updateEffectWithKey];

    NSString * key = [NSString stringWithFormat:@"%@.style", self.masqBackground.identifier];
    int style = [[%c(MASQThemeManager) prefs] integerForKey:key];
    self.masqBackground.alpha = !(style == 0);
    self.masqBackground.hidden = style == 0;
  }

  if (!self.masqBackground && !self.backgroundView) { //lockscreen does not set it for some reason
    CGRect r = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.trueWidth, self.view.bounds.size.height);
    [self.view.superview insertSubview:self.masqBackground = [[%c(MASQArtworkBlurView) alloc] initWithFrame:r] atIndex:0];
    self.masqBackground.imageHost = self.headerView.artworkView;
    self.masqBackground.identifier = @"LS";
    // self.masqBackground.hidden = YES;
    // self.masqBackground.clipsToBounds = YES;
    [self.masqBackground updateEffectWithKey];
    [self.masqBackground updateArtwork:nil];
  }

  %orig;
}

-(void)viewDidLayoutSubviews {
  %orig;
  if (!self.backgroundView && self.masqBackground) {

    // ideal refsize for lockscreen
    CGRect propose = CGRectMake(0, 0, self.view.superview.superview.bounds.size.width, self.view.bounds.size.height);
    if (!CGRectEqualToRect(self.masqBackground.bounds, propose))
    self.masqBackground.frame = propose; //jumpy without this if

    // needed for ls rounded corners
    [self.masqBackground _setContinuousCornerRadius:self.view.layer.maskedCorners * .85];
  }
}
%end




// ios 12.2 + ?
%hook MRPlatterViewController
// %property (nonatomic, assign) float trueWidth;
%property (nonatomic, retain) MASQArtworkBlurView * masqBackground;

-(void)setBackgroundView:(UIView *)arg1 { // add the cc background 11 - 12.4
  %orig;

  if (!self.masqBackground) {
    [arg1 addSubview:self.masqBackground = [[%c(MASQArtworkBlurView) alloc] initWithFrame:arg1.bounds]];
    self.masqBackground.identifier = @"CC";
    self.masqBackground.imageHost = self.nowPlayingHeaderView.artworkView;
  }
}

//need to investigate why it doesnt update based on my notification :/
-(void)_updateHeaderUI { // 12.2 + update cc
  %orig;

  if (self._continuousCornerRadius && self.style == 1)
  [self.masqBackground _setContinuousCornerRadius:self._continuousCornerRadius*0.5];

  // NSString * key = [NSString stringWithFormat:@"%@.style", self.masqBackground.identifier];
  // int style = [[%c(MASQThemeManager) prefs] integerForKey:key];
  // self.masqBackground.alpha = !(style == 0) || [%c(SBMediaController) sharedInstance].hasTrack;
  // self.masqBackground.hidden = style == 0 || ![%c(SBMediaController) sharedInstance].hasTrack;

  // dispatch_async
  [self.masqBackground updateArtwork:nil];
}

-(void)viewWillAppear:(BOOL)arg1 { //cc/ls present

  if (self.masqBackground) { // update cc on changes / ls on change
    if ([self.masqBackground.identifier hasPrefix:@"CC"])
    {
      // trying to hide cc when disabled
      NSString * key = [NSString stringWithFormat:@"%@.style", self.masqBackground.identifier];
      int style = [[%c(MASQThemeManager) prefs] integerForKey:key];
      self.masqBackground.alpha = !(style == 0);
      self.masqBackground.hidden = style == 0;

      // woot it worked!
      // if will appear and closed form
      if (arg1 && self.nowPlayingHeaderView.style == 1)
      [self.masqBackground updateEffectWithKey];

      // if (self.masqBackground.effectView.effect._style != style)
      if (self.nowPlayingHeaderView.style == 0) // this means its opened and I shouldnt resize unless
      // that being said I do need to update the style on changes so this work work exactly either
      if (style != 0 && self.style == 0)
      [self.masqBackground updateEffectWithKey];
    }

    // only do this when control center is invoked to avoid force touch resize monster
    // needed to update on pref changes for ls & cc
    if ([self.masqBackground.identifier hasPrefix:@"LS"])
    [self.masqBackground updateEffectWithKey];
  }

  if (!self.masqBackground && !self.backgroundView)
  { //lockscreen does not set it for some reason, so here we stick it in

    CGRect r = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view.superview insertSubview:self.masqBackground = [[%c(MASQArtworkBlurView) alloc] initWithFrame:r] atIndex:0];
    self.masqBackground.identifier = @"LS";
    // self.masqBackground.hidden = YES;
    // [self.masqBackground _setContinuousCornerRadius:self._continuousCornerRadius];
  }
  %orig;
}

-(void)viewDidLayoutSubviews { // lockscreen 11 - 12.4 super awareness for pee
  %orig;
  if (!self.backgroundView && self.masqBackground)
  {
    // update frame to the true size
    // bail incase we arent ready (does nothing noticable tho)
    if (self.view.superview.superview.bounds.size.width == 0) return;
    if (self.view.bounds.size.height == 0) return;


    CGRect propose = CGRectMake(0, 0, self.view.superview.superview.bounds.size.width, self.view.bounds.size.height);
    if (!CGRectEqualToRect(self.masqBackground.bounds, propose))
    self.masqBackground.frame = propose; //jumpy without this if, expand on it for that bug above

    // lockscreen alernative12.2 + since its self._continuousCornerRadius = nil
    [self.masqBackground _setContinuousCornerRadius:self.view.layer.maskedCorners*0.85];
  }

  // does nothing
  // // the cc
  // if (self.backgroundView && self.masqBackground)
  // {
  //   if (self.view.superview.superview.bounds.size.width == 0) return;
  //   if (self.view.bounds.size.height == 0) return;
  //
  //   CGRect propose = CGRectMake(0, 0, self.view.superview.superview.bounds.size.width, self.view.bounds.size.height);
  //   if (!CGRectEqualToRect(self.masqBackground.bounds, propose))
  //   self.masqBackground.frame = propose; //jumpy without this if, expand on it for that bug above
  // }
}
%end
