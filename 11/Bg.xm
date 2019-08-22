#import "Interfaces.h"

%hook MediaControlsPanelViewController
%property (nonatomic, retain) MASQArtworkBlurView * masqBackground;

-(void)setBackgroundView:(UIView *)arg1
{
  %orig;

  if (!self.masqBackground)
  { // ios 11 - 12.4 Control Center platter add method (this viewcontroller is only 11-12.1.2)
    [arg1 addSubview:self.masqBackground = [[%c(MASQArtworkBlurView) alloc] initWithFrame:arg1.bounds]];
    self.masqBackground.imageHost = self.headerView.artworkView; // ios 11-12.1.2
    self.masqBackground.identifier = @"CC";
  }
}

-(void)viewWillAppear:(BOOL)arg1 { //cc is invoked

  if (self.masqBackground) { // updating the existing view

    if (self.view.layer)
    { // cc rounded corner target
      [self.masqBackground _setContinuousCornerRadius:self.view.layer.maskedCorners*0.99];
    }

    if ([self.masqBackground.identifier hasPrefix:@"CC"])
    { // control center visibility case, potentially not needed?
      // ios 11-11.1.12
      if ([self respondsToSelector:@selector(mediaControlsPlayerState)])
      self.masqBackground.hidden = (self.mediaControlsPlayerState == 0);
      // higher ios doesnt have this anymore
      else self.masqBackground.hidden = NO;
    }

    // CC+LS check for preference change
    [self.masqBackground updateEffectWithKey];

    // CC+LS check for new audio playing / killed the app
    [self.masqBackground updateVisibility];
    // potentiall noy needed when using above method
    // NSString * key = [NSString stringWithFormat:@"%@.style", self.masqBackground.identifier];
    // int style = [[%c(MASQThemeManager) prefs] integerForKey:key];
    // self.masqBackground.alpha = !(style == 0);
    // self.masqBackground.hidden = style == 0;
  }

  if (!self.masqBackground && !self.backgroundView)
  { // adding the lockscreen view by catching that it doesn't set a backgroundView
    CGRect r = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view.superview insertSubview:self.masqBackground = [[%c(MASQArtworkBlurView) alloc] initWithFrame:r] atIndex:0];
    self.masqBackground.imageHost = self.headerView.artworkView;
    self.masqBackground.identifier = @"LS";
    // i think setting above trigger below so shouldnt be neccessary
    // [self.masqBackground updateEffectWithKey];
    // [self.masqBackground updateArtwork:nil];
  }

  %orig;
}

-(void)viewDidLayoutSubviews { // super lockscreen updates
  %orig;
  if (!self.backgroundView && self.masqBackground)
  { // update corner / frame when it comes in
    CGRect propose = CGRectMake(0, 0, self.view.superview.superview.bounds.size.width, self.view.bounds.size.height);
    if (!CGRectEqualToRect(self.masqBackground.bounds, propose))
    self.masqBackground.frame = propose; //jumpy without this if

    // setting ls rounded corners / maintaining transitional corners
    [self.masqBackground _setContinuousCornerRadius:self.view.layer.maskedCorners * .85];
  }
}
%end




// ios 12.2 + ? , main difference is nowPlayingHeaderView instead of headerView + corner rad
%hook MRPlatterViewController
%property (nonatomic, retain) MASQArtworkBlurView * masqBackground;

-(void)setBackgroundView:(UIView *)arg1 { // add the cc background 11 - 12.4
  %orig;

  if (!self.masqBackground)
  { // control center is the only view controller setting a backgroundView
    [arg1 addSubview:self.masqBackground = [[%c(MASQArtworkBlurView) alloc] initWithFrame:arg1.bounds]];
    self.masqBackground.identifier = @"CC";
    self.masqBackground.radiusHost = self;
    self.masqBackground.imageHost = self.nowPlayingHeaderView.artworkView;
  }
}

//need to investigate why it doesnt update based on my notification :/
-(void)_updateHeaderUI { // 12.2 + update cc
  %orig;

  // dispatch_async
  // Potentially necessary for the LS!!!!!!!!! not so much cc
  if ([self.masqBackground.identifier hasPrefix:@"LS"])
  [self.masqBackground updateArtwork:nil];
}

-(void)viewWillAppear:(BOOL)arg1 { //cc/ls present

  if (self.masqBackground) { // update cc on changes / ls on change
    // if ([self.masqBackground.identifier hasPrefix:@"CC"])
    // {
      // hide cc if just disabled
      [self.masqBackground updateVisibility];
      [self.masqBackground updateEffectWithKey];
    // }

    // only do this when control center is invoked to avoid force touch resize monster
    // needed to update on pref changes for ls since it hides itself when disabled
    // else if ([self.masqBackground.identifier hasPrefix:@"LS"])
    // [self.masqBackground updateEffectWithKey];
  }

  if (!self.masqBackground && !self.backgroundView)
  { //lockscreen controller does not set a bg view, so here we catch it

    CGRect r = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view.superview insertSubview:self.masqBackground = [[%c(MASQArtworkBlurView) alloc] initWithFrame:r] atIndex:0];
    self.masqBackground.radiusHost = self.view;
    self.masqBackground.identifier = @"LS";
    // self.
    // self.masqBackground.imageHost = self.nowPlayingHeaderView.artworkView; // intentionally disabled here
    // self.masqBackground.hidden = YES;
    // [self.masqBackground _setContinuousCornerRadius:self._continuousCornerRadius];
  }
  %orig;
}

-(void)viewDidLayoutSubviews { // lockscreen 11 - 12.4 super awareness
  %orig;

  if (!self.backgroundView && self.masqBackground)
  { // LS:  update frame / corners to the true size

    // [self updateCorners];
    // [self.masqBackground updateRadius];
    // lockscreen alernative12.2 + since its self._continuousCornerRadius = nil
    // [self.masqBackground _setContinuousCornerRadius:self.view.layer.maskedCorners*0.85];

    // if (self.view.superview.superview.bounds.size.width == 0) return;
    // if (self.view.bounds.size.height == 0) return;

    CGRect propose = CGRectMake(0, 0, self.view.superview.superview.bounds.size.width, self.view.bounds.size.height);
    if (!CGRectEqualToRect(self.masqBackground.bounds, propose))
    self.masqBackground.frame = propose; //jumpy without this if, expand on it for that bug above
  }
}
%end
