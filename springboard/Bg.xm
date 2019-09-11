#import "Interfaces.h"

%hook MediaControlsPanelViewController
%property (nonatomic, retain) MASQArtworkEffectView * masqBackground;

-(void)setBackgroundView:(UIView *)arg1
{
  %orig;

  if (!self.masqBackground)
  { // ios 11 - 12.4 Control Center platter add method (this viewcontroller is only 11-12.1.2)

    // Initialize and assign property with:
    // - arg1:view it's being added to
    // - arg2:object that has _continuousCornerRadius set, or a .layer with rounded corners
    // - arg3:an imageview to replicate
    // set the identifier, this is used to monitor preference key changes.
    self.masqBackground = [[%c(MASQArtworkEffectView) alloc] initWithFrameHost:arg1 radiusHost:self.view imageHost:self.headerView.artworkView];
    self.masqBackground.identifier = kControlCenterKey;
    [arg1 addSubview:self.masqBackground];
  }
}

-(void)viewWillAppear:(BOOL)arg1 { //cc is invoked

  if (self.masqBackground)
  { // update cc & ls on pref / audio source changes

    // if ([self.masqBackground.identifier hasPrefix:kControlCenterKey])
    // { // there is a special case to avoid a visual glitch when closing other cc modusles
    //    if (self.headerView.style == 0)
    //    [self.masqBackground updateEffect];
    //    else
    //    [self.masqBackground updateEffect];
    // }
    // else // lockscreen can update it with no worries
    // [self.masqBackground updateEffect];

    // for both
    [self.masqBackground updateVisibility];
    }

  if (!self.masqBackground && !self.backgroundView)
  { // adding the lockscreen view by catching that it doesn't set a backgroundView

    self.masqBackground = [[%c(MASQArtworkEffectView) alloc] initWithFrameHost:self.view.superview radiusHost:self.view imageHost:self.headerView.artworkView];
    self.masqBackground.identifier = kDashBoardKey;
    // [self.masqBackground updateArtwork:nil];

    [self.view.superview insertSubview:self.masqBackground atIndex:0];
  }

  if(!self.masqBackground && [self.delegate isKindOfClass:%c(MediaControlsEndpointsViewController)])
  {
        self.masqBackground = [[%c(MASQArtworkEffectView) alloc] initWithFrameHost:self.view radiusHost:self.view imageHost:self.headerView.artworkView];
        self.masqBackground.identifier = kControlCenterKey;
        [self.view addSubview:self.masqBackground];
  }
  %orig;
}

-(void)viewDidLayoutSubviews { // super lockscreen updates
  if (!self.backgroundView && self.masqBackground)
  { // update frame when it comes in
    if (self.view.superview.superview)
    {
      CGRect propose = CGRectMake(0, 0, self.view.superview.superview.bounds.size.width, self.view.bounds.size.height);
      if (!CGRectEqualToRect(self.masqBackground.bounds, propose))
      self.masqBackground.frame = propose; //jumpy without this if
    }
  }

  %orig;
}
%end


// ios 12.2 + ? , main difference is nowPlayingHeaderView instead of headerView + corner rad
%hook MRPlatterViewController
%property (nonatomic, retain) MASQArtworkEffectView * masqBackground;

-(void)viewWillAppear:(BOOL)arg1
{ //cc/ls present

  if (!self.masqBackground && !self.backgroundView)
  { //add lockscreen controller, it does not set a bg view so here we catch it

    // Initialize and assign property with:
    // - arg1:view it's being added to
    // - arg2:object that has _continuousCornerRadius set, or a .layer with rounded corners
    // - arg3:an imageview to replicate
    // set the identifier, this is used to monitor preference key changes.
    self.masqBackground = [[%c(MASQArtworkEffectView) alloc] initWithFrameHost:self.view.superview radiusHost:self.view imageHost:self.nowPlayingHeaderView.artworkView];
    self.masqBackground.identifier = kDashBoardKey;
    [self.view.superview insertSubview:self.masqBackground atIndex:0];
  }

  %orig;
}

-(void)setBackgroundView:(UIView *)arg1
{ // add the cc background 11 - 12.4 (VC is only 12.2 +)
  %orig;

  if (!self.masqBackground)
  { // control center is the only view controller calling this method

    // Initialize and assign property with:
    // - arg1:view it's being added to
    // - arg2:object that has _continuousCornerRadius set, or a .layer with rounded corners
    // - arg3:an imageview to replicate
    // set the identifier, this is used to monitor preference key changes.
    self.masqBackground = [[%c(MASQArtworkEffectView) alloc] initWithFrameHost:arg1 radiusHost:self imageHost:self.nowPlayingHeaderView.artworkView];
    self.masqBackground.identifier = kControlCenterKey;
    [arg1 addSubview:self.masqBackground];
  }
}

-(void)viewDidLayoutSubviews
{ // super lockscreen updates for the drop in
  // this if staement is extremely important to avoi cc monsters
  if (!self.backgroundView && self.masqBackground)
  { // update frame when it comes in
    if (self.view.superview)
    {

      CGRect propose = CGRectMake(0, 0, self.view.superview.superview.bounds.size.width, self.view.bounds.size.height);
      if (!CGRectEqualToRect(self.masqBackground.bounds, propose))
      self.masqBackground.frame = propose; //jumpy without this if
    }
  }

  %orig;
}

%end
