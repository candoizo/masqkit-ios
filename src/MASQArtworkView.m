#import "MASQArtworkView.h"
#import "MASQThemeManager.h"
#import "MediaRemote/MediaRemote.h"
#import "UIImageView+MASQRotate.h"
#import "MASQContextManager.h"
#import "MASQThemeContext.h"

@implementation MASQArtworkView
-(MASQThemeContext *)contextResult {

  MASQThemeContext * con = [[MASQThemeContext alloc] initWithBundle:self.currentTheme];

  return con;
}

-(id)init {
  self = [super init];
  self.userInteractionEnabled = [NSBundle.mainBundle.bundleIdentifier isEqualToString:@"com.apple.springboard"];
  return self;
}

-(id)initWithThemeKey:(NSString *)key {
  if (self = [self init])
  {
    _identifier = key;
    [MASQContextManager.sharedInstance registerView:self];
    [self addSubview:[self underlayView]];
    [self addSubview:[self containerView]];
    [self addSubview:[self overlayView]];
    [self updateTheme]; // apply theme to the views
  }
  return self;
}

-(id)initWithThemeKey:(NSString *)key neverAnimate:(BOOL)arg2 {
  if (self = [self init])
  {
    _identifier = key;
    self.neverAnimate = arg2;
    [MASQContextManager.sharedInstance registerView:self];
    [self addSubview:[self underlayView]];
    [self addSubview:[self containerView]];
    [self addSubview:[self overlayView]];
    [self updateTheme]; // apply theme to the views
  }
  return self;
}

-(id)initWithThemeKey:(NSString *)arg1 frameHost:(id)arg2 imageHost:(id)arg3 {
  if (self = [self initWithThemeKey:arg1])
  {
    self.frameHost = arg2;
    self.imageHost = arg3;
  }
  return self;
}

-(id)initWithThemeKey:(NSString *)arg1 frameHost:(id)arg2 imageHost:(id)arg3 neverAnimate:(BOOL)arg4 {
    if (self = [self initWithThemeKey:arg1 neverAnimate:arg4])
    {
      self.frameHost = arg2;
      self.imageHost = arg3;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

  // if (!self.activeAudio)
  // self.hidden = self.artworkImageView.image == nil && !self.activeAudio;
  if ([keyPath isEqualToString:@"frame"])
  { // if ours isnt already matching
    if (!CGRectEqualToRect(self.frameHost.frame, self.frame))
    [self updateFrame];
  }

  else if ([keyPath isEqualToString:@"image"])
  {
    [self updateArtwork:nil];
  }

  else if (self.centerHost && [keyPath isEqualToString:@"center"])
  {
    [self updateCenter];
  }
}

-(void)themeUpdating {
  NSBundle * theme = self.currentTheme;
  if (theme)
  {
    NSString * themeName = theme.bundlePath.lastPathComponent;
    BOOL animates = self.wantsAnimation = [themeName hasPrefix:@"🌀"];

    self.ratio = [[themeName componentsSeparatedByString:@"@"].lastObject floatValue] / 100;
    if (!self.ratio) self.ratio = 1;

    // [self.artworkImageView.layer removeAllAnimations];
    // if (self.hasAnimation && !animates)
    if (self.hasAnimation || (self.imageHost && !animates)) //this one seems better??????
    { // if the view was marked as having an animation
      // this notices that the updated theme does not have one
      //
      // we must remove them to avoid oddly oriented artwork
      // and then we can mark it in a clean state
      ///
      // remove potential transform & animations
      [self.artworkImageView.layer removeAllAnimations];
      self.artworkImageView.transform = CGAffineTransformIdentity;
      self.hasAnimation = NO;
      self.isAnimating = NO;
    }

    // applying new theme assets
    ((UIImageView *)_containerView.maskView).image = [self maskImage];
    [_overlayView setBackgroundImage:[self overlayImage] forState:UIControlStateNormal];
    [_underlayView setBackgroundImage:[self underlayImage] forState:UIControlStateNormal];

    [self updateFrame]; // update everything to proper layout

    if (animates && self.imageHost && self.hashCache > 0)
    { // wants to animate, has an image
      // probably I need to check that some thing exists
      // checking or the hash cache > 0 seems to avoid the initial askewing
      // so I think this what causes the break on first loads
      // I think I need to avoid this but then check if it wants animations
      [self updatePlaybackState];
    }
  }
}

-(void)updateTheme
{ // for some reason this resets the artwork when called i really dunno why
  NSString * ident = self.identifier;
  if (ident)
  {
    MASQContextManager * shared = [MASQContextManager sharedInstance];
    NSBundle * newTheme = shared.themes[ident];
    NSBundle * activeTheme = self.currentTheme;

    if (activeTheme == newTheme)
    return; // theme does not appear to have changed

    self.currentTheme = newTheme;
    // self.artworkImageView.transform = CGAffineTransformIdentity;
    [self themeUpdating];
  }
  else HBLogError(@"There was no identifier? This cannot be nil.");
}

-(void)updateCenter
{
  if (self.centerHost.center.y)
  self.center = self.centerHost.center;
}

-(void)updateFrame
{
  [UIView animateWithDuration:0/*CGRectEqualToRect(self.frame, CGRectZero) ? 0 : 0.3*/ animations:^
  {

    // NSString * key = [NSString stringWithFormat:@"%@.scale", self.identifier];
    // if ([MASQThemeManager.prefs valueForKey:key])
    // {
    //   double os = [MASQThemeManager.prefs doubleForKey:key];
    //   CGRect overscale = CGRectMake(0,0,self.frameHost.bounds.size.width * os, self.frameHost.bounds.size.height * os);
    //
    //   self.bounds = overscale;
    //   self.center = self.frameHost.center;
    // }
    // else {
      // self.bounds = self.frameHost.bounds;
      // self.center = self.frameHost.center;
    // }
    // above would implement scaling
    UIView * frameHost = self.frameHost;
    self.bounds = frameHost.bounds;
    self.center = frameHost.center;
    _containerView.maskView.frame = _containerView.frame;
    float ratio = self.ratio;
    // _artworkImageView.frame = _containerView.frame;
    // _artworkImageView.transform = CGAffineTransformMakeScale(ratio, ratio);

    _artworkImageView.bounds = CGRectMake(_containerView.bounds.origin.x,_containerView.bounds.origin.y,self.bounds.size.width * ratio, self.frame.size.height * ratio);
    _artworkImageView.center = _containerView.center;
  } completion:nil];
  if (self.centerHost) [self updateCenter];

  // probably should actually be in the setImageHost
  // but yay it works :D
  // if ([self wantsAnimation] && !self.hasAnimation && self.imageHost && self.hashCache > 0)
  // // if we want to animate, but dont have one yet
  // // and we are sure the imagehost exists, we can begin!
  // [self updatePlaybackState];
}

-(void)updateArtwork:(UIImage *)img {

  if ([img isKindOfClass:NSClassFromString(@"UIImage")])
  { // UIImage was supplied
    self.hashCache = img.hash;
    self.artworkImageView.image = img;
    // return;
  }

  else if (self.imageHost)
  { // imageHost is set
    UIImageView * ihost = self.imageHost;
    if ([ihost respondsToSelector:@selector(image)])
    { // and has a image methods
      UIImage * image = [ihost image];
      if ([image isKindOfClass:NSClassFromString(@"UIImage")])
      { // image returns a valid image!
        if (image.hash != self.hashCache)
        { // image is not the same as the last one cached!
          self.hashCache = image.hash;
          self.artworkImageView.image = image;
        }
      }
    }
  }
  else
  {
    HBLogError(@"imageHost is not like UIImageView, nor was arg1 a UIImage so artwork didnt update, perhaps you want a different imageHost?");
    return;
  }

  // when a new artwork view is created, this is the last method called
  // it seems to break when we do most other things before having a real image
  //
  // if it wants to animate, has an image, has active audio, but didnt get the animation yet
  // if its flagged to never animate we obviously will not tho
  if (self.wantsAnimation && self.hashCache && self.activeAudio && !self.hasAnimation)
  [self tapAnimate];
}

-(void)setImageHost:(id)arg1 {
  _imageHost = arg1;
  if (_imageHost)
  {
    [_imageHost addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    if ([_imageHost respondsToSelector:@selector(image)])
    [_imageHost addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    [self updateArtwork:nil];
  }
}

-(void)setFrameHost:(id)arg1 {
  _frameHost = arg1;
  if (_frameHost)
  {
    [_frameHost addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [self updateFrame];
  }
}

-(void)setCenterHost:(id)arg1 {
  _centerHost = arg1;
  if (self.centerHost)
  {
    [self.centerHost addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
    self.center = self.centerHost.center;
  }
}

-(id)containerView
{
  UIView * c = [[UIView alloc] initWithFrame:self.bounds];
  c.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; //resize to super width
  c.center = self.center;
  c.userInteractionEnabled = NO;

  UIImageView * maskView = [[UIImageView alloc] initWithFrame:c.bounds];
  maskView.contentMode = UIViewContentModeScaleAspectFit;
  maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; //resize to super width

  c.maskView = maskView;
  c.maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; //resize to super width

  _artworkImageView = [[UIImageView alloc] initWithFrame:self.bounds];
  _artworkImageView.contentMode = UIViewContentModeScaleAspectFill; // fixed video still aspect
  [c addSubview:_artworkImageView];// [c addSubview:[self artworkImageView]];
  return _containerView = c;
}

-(id)underlayView {
  UIButton * u = [[UIButton alloc] initWithFrame:self.bounds];
  u.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; //resize to super width
  u.userInteractionEnabled = NO;
  u.center = self.center;
  return _underlayView = u;
}

-(id)overlayView {
  _overlayView = [[UIButton alloc] initWithFrame:self.bounds];
  [_overlayView addTarget:self action:@selector(tapArtwork:) forControlEvents:UIControlEventTouchUpInside];
  _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; //resize to super width
  _overlayView.center = self.center;
  return _overlayView;
}

-(void)tapArtwork:(id)sender
{
  if (NSClassFromString(@"SBMediaController"))
  { // We are in SpringBoard
    SBApplication * app = [[NSClassFromString(@"SBMediaController") sharedInstance] nowPlayingApplication];
    if (app)
    {
      if (app && [UIApplication.sharedApplication respondsToSelector:@selector(launchApplicationWithIdentifier:suspended:)])
      [UIApplication.sharedApplication launchApplicationWithIdentifier:app.bundleIdentifier suspended:NO];

      if (NSClassFromString(@"SBCoverSheetPresentationManager"))
      { // dismiss notification center ios 11.x - 12.x
        SBCoverSheetPresentationManager * nc = [NSClassFromString(@"SBCoverSheetPresentationManager") sharedInstance];
        BOOL deviceUnlocked = ((SBLockStateAggregator *)[NSClassFromString(@"SBLockStateAggregator") sharedInstance]).lockState == 1;
        if (nc.isVisible && deviceUnlocked)
        [nc setCoverSheetPresented:NO animated:YES withCompletion:nil];
      }
    }
  }
}

/// images
-(UIImage *)maskImage
{ // tries to load it efficiently and fallsback to old behaviour if not possible
  NSBundle * theme = self.currentTheme;
  return theme ?
  [UIImage imageNamed:@"Mask" inBundle:theme compatibleWithTraitCollection:nil] ?:
  [UIImage imageWithContentsOfFile:[theme pathForResource:@"Mask" ofType:@"png"]]
  : nil;
}

-(UIImage *)overlayImage
{
  NSBundle * theme = self.currentTheme;

  UIImage * overlay = [UIImage imageNamed:@"Overlay" inBundle:theme compatibleWithTraitCollection:nil];

  if (!overlay)
  overlay = [UIImage imageWithContentsOfFile:[theme pathForResource:@"Overlay" ofType:@"png"]];

  return overlay ?: nil;

  // BOOL rootApp = NSClassFromString(@"SBMediaController") || NSClassFromString(@"PreferencesAppController");
  // if (theme)
  // return rootApp ? [UIImage imageNamed:@"Overlay" inBundle:theme compatibleWithTraitCollection:nil] : [UIImage imageWithContentsOfFile:[theme pathForResource:@"Overlay" ofType:@"png"]];
  // else return nil;
  // return theme ? //theme exists
  // NSClassFromString(@"SBMediaController") || NSClassFromString(@"PreferencesAppController") ?
  // // in springboad/prefs use faster way
  // [UIImage imageNamed:@"Overlay" inBundle:theme compatibleWithTraitCollection:nil] :
  // // use old way since app sandbox is messed
  // [UIImage imageWithContentsOfFile:[theme pathForResource:@"Overlay" ofType:@"png"]]
  // : nil;

  // return theme ?
  // [UIImage imageNamed:@"Overlay" inBundle:theme compatibleWithTraitCollection:nil] ?:
  // [UIImage imageWithContentsOfFile:[theme pathForResource:@"Overlay" ofType:@"png"]]
  // : nil;
}

-(UIImage *)underlayImage
{
  NSBundle * theme = self.currentTheme;

  UIImage * image = [UIImage imageNamed:@"Underlay" inBundle:theme compatibleWithTraitCollection:nil];

  if (!image)
  image = [UIImage imageWithContentsOfFile:[theme pathForResource:@"Underlay" ofType:@"png"]];

  return image ?: nil;

  // return theme ? //theme exists
  // NSClassFromString(@"SBMediaController") || NSClassFromString(@"PreferencesAppController") ?
  // // in springboad/prefs use faster way
  // [UIImage imageNamed:@"Underlay" inBundle:theme compatibleWithTraitCollection:nil] :
  // // use old way since app sandbox is messed
  // [UIImage imageWithContentsOfFile:[theme pathForResource:@"Underlay" ofType:@"png"]]
  // : nil;

  // return theme ?
  // [UIImage imageNamed:@"Underlay" inBundle:theme compatibleWithTraitCollection:nil] ?:
  // [UIImage imageWithContentsOfFile:[theme pathForResource:@"Underlay" ofType:@"png"]]
  // : nil;
}

-(void)updatePlaybackState {
  self.activeAudio = [MASQContextManager sharedInstance].activeAudio.boolValue;

  // this seems to have caused some breaking shit ?
  // if ([self wantsAnimation])
  // [self tapAnimate];
}

-(void)setActiveAudio:(BOOL)arg1 {
  _activeAudio = arg1;

  // this thing kept fucking the size up
  if (self.hashCache)
  if ((self.wantsAnimation && self.imageHost && self.activeAudio) || self.hasAnimation)
  { // check if has animation??
    [self tapAnimate];
  }
}

// fail or not so much idk ffuck you apple
-(void)tapAnimate {
  // dispatch_async(dispatch_get_main_queue(), ^{

  if (self.wantsAnimation && !self.neverAnimate)
  {
    if (!self.hasAnimation)
    { // first animation has been applied once
      // dispatch_async(dispatch_get_main_queue(), ^{
      [self.artworkImageView __debug_rotate360WithDuration:2.0f repeatCount:0] ;
      // });
      self.hasAnimation = YES;
      self.isAnimating = YES;
    }
    else
    { // the view already has an animation
      if (self.activeAudio)
      {
        [self.artworkImageView __debug_resumeAnimations];
        self.isAnimating = YES;
      }
      else
      {
        [self.artworkImageView __debug_pauseAnimations];
        self.isAnimating = NO;
      }
    }

    return;
  }
  else return;






  // // old stuff
  // if (!self.hasAnimation)
  // { // if it has never animated before
  //   // and we actually want something playing before continuing
  //   if (NSClassFromString(@"SBMediaController"))
  //   { // i think this one initializes just before the song starts playing
  //     dispatch_async(dispatch_get_main_queue(), ^{
  //     [self.artworkImageView __debug_rotate360WithDuration:2.0f repeatCount:0] ;
  //     });
  //     // now this imageview is practically unusable for other themes
  //     // this will help us figure out when to reinit i
  //     self.hasAnimation = YES;
  //     self.isAnimating = YES;
  //
  //     return;
  //   }
  //
  //
  //
  //
  //   else if (!self.activeAudio) return;
  //
  //   [self.artworkImageView __debug_rotate360WithDuration:2.0f repeatCount:0] ;
  //
  //   // now this imageview is practically unusable for other themes
  //   // this will help us figure out when to reinit i
  //   self.hasAnimation = YES;
  //   self.isAnimating = YES;
  // }
  //
  //
  //
  //
  // // });
  // else
  // { // it has animation keys already so just pause if needed
  //   if (self.activeAudio)
  //   {
  //     [self.artworkImageView __debug_resumeAnimations];
  //     self.isAnimating = YES;
  //   }
  //   else
  //   {
  //     // if (!NSClassFromString(@"SBMediaController"))
  //     // {
  //     [self.artworkImageView __debug_pauseAnimations];
  //     self.isAnimating = NO;
  //     // }
  //   }
  // }
}


// -(void)__test_compareLookup {
// // Sep 16 21:35:12 X Preferences[9376] <Warning>: 1000x hash lookup executionTime = 0.000637
// // Sep 16 21:35:12 X Preferences[9376] <Warning>: 1000x old executionTime = 0.100794
// // Sep 16 21:36:01 X Preferences[9376] <Warning>: 1000x hash lookup executionTime = 0.000627
// // Sep 16 21:36:01 X Preferences[9376] <Warning>: 1000x old executionTime = 0.105350
//
//   MASQContextManager * shared = [MASQContextManager sharedInstance];
//   NSString * ident = self.identifier;
//   int co = 0;
//
//   NSDate *methodStart = [NSDate date];
//   while (co < 1000) {
//     NSBundle * active = shared.themes[ident];
//     if (active != nil)
//     co++;
//   }
//   NSDate *methodFinish = [NSDate date];
//   NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
//   NSLog(@"1000x hash lookup executionTime = %f", executionTime);
//
//   co = 0;
//   methodStart = [NSDate date];
//   while (co < 1000) {
//     NSBundle * currentTheme = [MASQThemeManager themeBundleForKey:ident];
//     if (currentTheme != nil)
//     co++;
//   }
//   methodFinish = [NSDate date];
//   executionTime = [methodFinish timeIntervalSinceDate:methodStart];
//   NSLog(@"1000x old executionTime = %f", executionTime);
// }
//
// -(void)__test_compareLoader {
// // damn 500% faster ...

// ContextManager Stress Test ()
// Loading a new theme 1000x times.
// // Sep 17 10:12:53 X SpringBoard[10968] <Warning>: new executionTime = 0.053621
// // Sep 17 10:12:53 X SpringBoard[10968] <Warning>: old executionTime = 0.271982



//   MASQContextManager * shared = [MASQContextManager sharedInstance];
//   NSString * ident = self.identifier;
//   NSBundle * active = shared.themes[ident];
//   int co = 0;
//
//   NSDate *methodStart = [NSDate date];


//   while (co < 1000) {
//     UIImage * img =  [UIImage imageNamed:@"Mask" inBundle:active compatibleWithTraitCollection:nil];
//     if (img != nil)
//     co++;
//   }
//   NSDate *methodFinish = [NSDate date];
//   NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
//   NSLog(@"1000x new executionTime = %f", executionTime);
//
//   co = 0;
//   methodStart = [NSDate date];
//   while (co < 1000) {
//     UIImage * img = [self maskImage];
//     // NSBundle * currentTheme = [MASQThemeManager themeBundleForKey:ident];
//     if (img != nil)
//     co++;
//   }
//   methodFinish = [NSDate date];
//   executionTime = [methodFinish timeIntervalSinceDate:methodStart];
//   NSLog(@"1000x old executionTime = %f", executionTime);
// }
@end



/*

MR Notification Notes

_MRMediaRemoteNowPlayingApplicationDidRegister
kMRMediaRemoteNowPlayingApplicationDidRegister
_MRMediaRemoteNowPlayingPlayerDidRegister




State Change Notifcations:
_MRMediaRemotePlayerPlaybackStateDidChangeNotification // somewhat overcalledf
_MRMediaRemotePlayerIsPlayingDidChangeNotification // another good candidate
_MRMediaRemotePlayerStateDidChange // good candidate

// 200 ms later
kMRMediaRemotePlayerStateDidChange
_kMRMediaRemotePlayerPlaybackStateDidChangeNotification

A track of all notifcations containing MR on springboard when the play button is pressed to start music

14552 ms  -[NSNotificationCenter postNotificationName:_MRMediaRemoteNowPlayingApplicationDidRegister object:0x0 userInfo:0x281f6f380]
 14554 ms     | -[NSNotificationCenter postNotificationName:kMRMediaRemoteNowPlayingApplicationDidRegister object:0x0 userInfo:0x2818115c0]
 14557 ms  -[NSNotificationCenter postNotificationName:_MRMediaRemoteNowPlayingPlayerDidRegister object:0x0 userInfo:0x28182ce60]
 14558 ms     | -[NSNotificationCenter postNotificationName:kMRMediaRemoteNowPlayingPlayerDidRegister object:0x0 userInfo:0x28182cb40]
 14561 ms  -[NSNotificationCenter postNotificationName:_MRMediaRemoteNowPlayingPlayerDidRegister object:0x0 userInfo:0x281f6eb80]
 14563 ms     | -[NSNotificationCenter postNotificationName:kMRMediaRemoteNowPlayingPlayerDidRegister object:0x0 userInfo:0x2818115c0]
 14565 ms  -[NSNotificationCenter postNotificationName:kMRPlaybackQueueCapabilitiesChangedNotification object:0x0 userInfo:0x281f65660]
 14590 ms  -[NSNotificationCenter postNotificationName:_MRMediaRemoteActivePlayerDidChange object:0x0 userInfo:0x281811560]
 14593 ms     | -[NSNotificationCenter postNotificationName:kMRMediaRemoteActivePlayerDidChange object:0x0 userInfo:0x281810c80]
 14595 ms     | -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerPlaybackStateDidChangeNotification object:0x0 userInfo:0x281f57ba0]
 14605 ms     | -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerIsPlayingDidChangeNotification object:0x0 userInfo:0x281f57ba0]
 14607 ms     | -[NSNotificationCenter postNotificationName:_kMRNowPlayingPlaybackQueueChangedNotification object:0x0 userInfo:0x28182ce60]
 14610 ms     |    | -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerNowPlayingInfoDidChangeNotification object:0x0 userInfo:0x281f57ba0]
 14612 ms     | -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerSupportedCommandsDidChangeNotification object:0x0 userInfo:0x281810f20]
 14615 ms     | -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerStateDidChange object:0x0 userInfo:0x281f65700]
 14628 ms  -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerSupportedCommandsDidChangeNotification object:0x0 userInfo:0x281811900]
 14629 ms     | -[NSNotificationCenter postNotificationName:kMRMediaRemotePlayerSupportedCommandsDidChangeNotification object:0x0 userInfo:0x281e42120]
 14846 ms  -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerStateDidChange object:0x0 userInfo:0x281efbf80]
 14848 ms     | -[NSNotificationCenter postNotificationName:kMRMediaRemotePlayerStateDidChange object:0x0 userInfo:0x28182c3c0]
 14850 ms  -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerStateDidChange object:0x0 userInfo:0x28182c3c0]
 14852 ms     | -[NSNotificationCenter postNotificationName:kMRMediaRemotePlayerStateDidChange object:0x0 userInfo:0x281f65f80]
 14937 ms  -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerPlaybackStateDidChangeNotification object:0x0 userInfo:0x281810b80]
 14939 ms     | -[NSNotificationCenter postNotificationName:_kMRMediaRemotePlayerPlaybackStateDidChangeNotification object:0x0 userInfo:0x28182ce60]
 14970 ms  -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerPlaybackStateDidChangeNotification object:0x0 userInfo:0x28182ce80]
 15029 ms     | -[NSNotificationCenter postNotificationName:_kMRMediaRemotePlayerPlaybackStateDidChangeNotification object:0x0 userInfo:0x281e41ec0]
 15046 ms  -[NSNotificationCenter postNotificationName:_kMRNowPlayingPlaybackQueueChangedNotification object:0x0 userInfo:0x281e420c0]
 15047 ms     | -[NSNotificationCenter postNotificationName:kMRPlayerPlaybackQueueChangedNotification object:0x0 userInfo:0x281e41ea0]
 15048 ms     | -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerNowPlayingInfoDidChangeNotification object:0x0 userInfo:0x281f65aa0]
 15049 ms     |    | -[NSNotificationCenter postNotificationName:kMRMediaRemotePlayerNowPlayingInfoDidChangeNotification object:0x0 userInfo:0x281fc85e0]
 15050 ms  -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerSupportedCommandsDidChangeNotification object:0x0 userInfo:0x281fca640]
 15050 ms     | -[NSNotificationCenter postNotificationName:kMRMediaRemotePlayerSupportedCommandsDidChangeNotification object:0x0 userInfo:0x281fc92e0]
 15051 ms  -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerSupportedCommandsDidChangeNotification object:0x0 userInfo:0x281fcaa40]
 15051 ms     | -[NSNotificationCenter postNotificationName:kMRMediaRemotePlayerSupportedCommandsDidChangeNotification object:0x0 userInfo:0x281fc8920]
 15052 ms  -[NSNotificationCenter postNotificationName:kMRMediaRemoteNowPlayingApplicationDidRegisterCanBeNowPlaying object:0x0 userInfo:0x281fcaa40]
 15084 ms  -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerPlaybackStateDidChangeNotification object:0x0 userInfo:0x281e41ee0]
 15085 ms     | -[NSNotificationCenter postNotificationName:_kMRMediaRemotePlayerPlaybackStateDidChangeNotification object:0x0 userInfo:0x281e422c0]
 15092 ms  -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerIsPlayingDidChangeNotification object:0x0 userInfo:0x2818106e0]
 15095 ms     | -[NSNotificationCenter postNotificationName:kMRMediaRemotePlayerIsPlayingDidChangeNotification object:0x0 userInfo:0x281fcaa40]
 15181 ms  -[NSNotificationCenter postNotificationName:_MRMediaRemoteOriginNowPlayingApplicationDidChangeNotification object:0x0 userInfo:0x2818119a0]
 15183 ms     | -[NSNotificationCenter postNotificationName:kMRMediaRemoteOriginNowPlayingApplicationDidChangeNotification object:0x0 userInfo:0x28182cb20]
 15185 ms     | -[NSNotificationCenter postNotificationName:kMRMediaRemoteNowPlayingApplicationDidChangeNotification object:0x0 userInfo:0x28182cb20]



State Change Notifcations:
_MRMediaRemotePlayerPlaybackStateDidChangeNotification // somewhat overcalledf
_MRMediaRemotePlayerIsPlayingDidChangeNotification // another good candidate - so this seems to be the best one for tracking playback state
_MRMediaRemotePlayerStateDidChange // good candidate  (not called by Prefernces hmm)

// 200 ms later
kMRMediaRemotePlayerStateDidChange
_kMRMediaRemotePlayerPlaybackStateDidChangeNotification


Settings app (only seems to fire after my listeners are added :/ )

 20780 ms  -[NSNotificationCenter postNotificationName:_kMRNowPlayingPlaybackQueueChangedNotification object:0x0 userInfo:0x2812fea00]
 20783 ms     | -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerNowPlayingInfoDidChangeNotification object:0x0 userInfo:0x2812d2260]

 20850 ms  -[NSNotificationCenter postNotificationName:_MRPlayerPlaybackQueueContentItemsChangedNotification object:0x0 userInfo:0x28129cd20]
 20851 ms     | -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerNowPlayingInfoDidChangeNotification object:0x0 userInfo:0x28129c7e0]
 27897 ms  -[NSNotificationCenter postNotificationName:_kMRNowPlayingPlaybackQueueChangedNotification object:0x0 userInfo:0x2812d3f20]
 27899 ms     | -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerNowPlayingInfoDidChangeNotification object:0x0 userInfo:0x281210060]

 27927 ms  -[NSNotificationCenter postNotificationName:_MRPlayerPlaybackQueueContentItemArtworkChangedNotification object:0x0 userInfo:0x2812103c0]
 27929 ms     | -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerNowPlayingInfoDidChangeNotification object:0x0 userInfo:0x2812d3000]
 27970 ms  -[NSNotificationCenter postNotificationName:_MRPlayerPlaybackQueueContentItemsChangedNotification object:0x0 userInfo:0x2812d31a0]
 27971 ms     | -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerNowPlayingInfoDidChangeNotification object:0x0 userInfo:0x2812d2f00]
 41548 ms  -[NSNotificationCenter postNotificationName:_kMRNowPlayingPlaybackQueueChangedNotification object:0x0 userInfo:0x281210460]
 41553 ms     | -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerNowPlayingInfoDidChangeNotification object:0x0 userInfo:0x2812fea00]
 41581 ms  -[NSNotificationCenter postNotificationName:_MRPlayerPlaybackQueueContentItemArtworkChangedNotification object:0x0 userInfo:0x2812ff760]
 41582 ms     | -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerNowPlayingInfoDidChangeNotification object:0x0 userInfo:0x2812e5a80]
 41641 ms  -[NSNotificationCenter postNotificationName:_MRPlayerPlaybackQueueContentItemsChangedNotification object:0x0 userInfo:0x2812101a0]
 41643 ms     | -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerNowPlayingInfoDidChangeNotification object:0x0 userInfo:0x281210380]

 42907 ms  -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerPlaybackStateDidChangeNotification object:0x0 userInfo:0x28129d8c0]
 42915 ms  -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerIsPlayingDidChangeNotification object:0x0 userInfo:0x281215fe0]

 42917 ms  -[NSNotificationCenter postNotificationName:0x1c97c41a8 object:0x2810aae80]
 42917 ms     | -[NSNotificationCenter postNotificationName:AVAudioSessionPickableRouteChangeNotification object:0x2810aae80 userInfo:0x0]

 43066 ms  -[NSNotificationCenter postNotificationName:_MRPlayerPlaybackQueueContentItemsChangedNotification object:0x0 userInfo:0x2812ff5e0]
 43068 ms     | -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerNowPlayingInfoDidChangeNotification object:0x0 userInfo:0x2812ff5c0]
 43313 ms  -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerPlaybackStateDidChangeNotification object:0x0 userInfo:0x2812103c0]
 43325 ms  -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerIsPlayingDidChangeNotification object:0x0 userInfo:0x281215fe0]
 43434 ms  -[NSNotificationCenter postNotificationName:_MRPlayerPlaybackQueueContentItemsChangedNotification object:0x0 userInfo:0x28129c600]
 43436 ms     | -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerNowPlayingInfoDidChangeNotification object:0x0 userInfo:0x2812d2d80]

*/
