#import "MASQArtworkView.h"
#import "MASQThemeManager.h"
#import "MediaRemote/MediaRemote.h"
#import "UIImageView+MASQRotate.h"

@implementation MASQArtworkView
-(id)initWithThemeKey:(NSString *)key
{
  if (self = [super init])
  {
    _identifier = key;
    self.userInteractionEnabled = NO;
    [self addSubview:[self underlayView]];
    [self addSubview:[self containerView]];
    [self addSubview:[self overlayView]];
    [self updateTheme];

    // [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateTheme)  name:UIApplicationDidBecomeActiveNotification object:nil];

    NSNotificationCenter * def = NSNotificationCenter.defaultCenter;
    [def addObserver:self selector:@selector(updateArtwork:)  name:@"_kMRMediaRemotePlayerNowPlayingInfoDidChangeNotification" object:nil];

    if (NSClassFromString(@"SBMediaController"))
    { // this artwork is in springboard

      // control center
      if ([key rangeOfString:@"CC"].location != NSNotFound)
      [def addObserver:self selector:@selector(updateTheme)  name:@"SBControlCenterControllerWillPresentNotification" object:nil];

      // lock screen
      else if ([key rangeOfString:@"LS"].location != NSNotFound)
      [def addObserver:self selector:@selector(updateTheme)  name:@"SBCoverSheetWillPresentNotification" object:nil];

      else // fallback incase of weird views
      [def addObserver:self selector:@selector(updateTheme)  name:UIApplicationDidBecomeActiveNotification object:nil];

    }
    else [def addObserver:self selector:@selector(updateTheme)  name:UIApplicationDidBecomeActiveNotification object:nil];

    [def addObserver:self selector:@selector(updatePlaybackState)  name:@"_MRMediaRemotePlayerPlaybackStateDidChangeNotification" object:nil];
    // get initial state (or maybe I should do this after I set theme)
    [self updatePlaybackState];

  }
  return self;
}

-(void)updatePlaybackState {
  // reminder: this works well ;P
  if (NSClassFromString(@"SBMediaController"))
  { // in springboard
    // return SBMediaController.sharedInstance.
    SBMediaController * sess = [NSClassFromString(@"SBMediaController") sharedInstance];
    if (sess)
    self.activeAudio = sess.isPlaying;
  }
  else if (NSClassFromString(@"AVAudioSession"))
  { // in an app
    AVAudioSession * sess = [NSClassFromString(@"AVAudioSession") sharedInstance];
    if (sess)
    self.activeAudio = [sess isOtherAudioPlaying];
  }
  else // use the hammer
  MRMediaRemoteGetNowPlayingInfo(
    dispatch_get_main_queue(), ^(CFDictionaryRef information) {

      NSDictionary *dict = (__bridge NSDictionary *)(information);
      NSString * state = dict[@"kMRMediaRemoteNowPlayingInfoPlaybackRate"];
      if (state)
      self.activeAudio = [state floatValue] != 0;
    }
  );

  // if (self.artworkImageView.image)
  // if ([self.currentTheme.bundlePath.lastPathComponent hasPrefix:@"🌀"])
  // { // wants to animate
  //   // if (self.activeAudio)
  //   // [self animate];
  //
  //     dispatch_async(dispatch_get_main_queue(), ^{
  //   if (self.activeAudio)
  //   [self.artworkImageView __debug_rotate360WithDuration:2.0f repeatCount:0];
  //   else
  //   [self.artworkImageView __debug_pauseAnimations];
  //     });
  // }
}

// fail
-(void)tapAnimate {
  // dispatch_async(dispatch_get_main_queue(), ^{
    [self.artworkImageView __debug_rotate360WithDuration:2.0f repeatCount:0];
  // });
}

// fail
-(void)__goAnimate {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.artworkImageView __debug_rotate360WithDuration:2.0f repeatCount:0];
  });
}

// fail
-(void)__grrrr {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self tapAnimate];
  });
}

-(void)__animate {

  CABasicAnimation *fullRotation;
  fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
  fullRotation.fromValue = @0;
  fullRotation.toValue = @((360 * M_PI) / 180);
  fullRotation.duration = 2;
  fullRotation.repeatCount = MAXFLOAT;

  // self.debuggg = fullRotation.description;
  // if (![fullRotation description])
  // self.debuggg = @"Failed?";


  [CATransaction begin];
  [self.artworkImageView.layer addAnimation:fullRotation forKey:@"360"];
  [CATransaction commit];
  // [self layoutSublayersOfLayer:self.artworkImageView.layer];
  // [self.artworkImageView layoutSublayersOfLayer:self.artworkImageView.layer];
  // [self.artworkImageView __debug_rotate360WithDuration:2.0f repeatCount:0];

  // for (UIImageView * v in self.subviews)
  // {
  //   if ([v isMemberOfClass:NSClassFromString(@"UIImageView")])
  //   [v __debug_rotate360WithDuration:2 repeatCount:0];
  // }
}

-(void)___fuck { //dafuq
  // [self __animate];
    [self __grrrr];
      // [self __invokeHack];
      //   [self tapAnimate];
      //     [self __goAnimate];
      //       [self __animate];
}


// fail
-(void)__invokeHack {
  SEL sel = @selector(__debug_rotateImageView);
  UIImageView * obj = self.artworkImageView;

  NSMethodSignature *methodSignature = [obj methodSignatureForSelector:sel];
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
  [invocation setTarget:obj];
  [invocation setSelector:sel];
  [invocation retainArguments];

  [invocation invoke];
}

-(void)dealloc {

  NSNotificationCenter * def = NSNotificationCenter.defaultCenter;
  [def removeObserver:self name:@"_kMRMediaRemotePlayerNowPlayingInfoDidChangeNotification" object:nil];
  [def removeObserver:self name:@"_MRMediaRemotePlayerPlaybackStateDidChangeNotification" object:nil];

  if ([self.identifier rangeOfString:@"CC"].location != NSNotFound)
  [def removeObserver:self name:@"SBControlCenterControllerWillPresentNotification" object:nil];

  else if ([self.identifier rangeOfString:@"LS"].location != NSNotFound)
  [def removeObserver:self name:@"SBCoverSheetWillPresentNotification" object:nil];

  else
  [def removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

}

-(id)initWithThemeKey:(NSString *)arg1 frameHost:(id)arg2 imageHost:(id)arg3
{
  if (self = [self initWithThemeKey:arg1])
  {
    self.frameHost = arg2;
    self.imageHost = arg3;
  }
  return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

  if ([keyPath isEqualToString:@"frame"])
  {
    // if ours isnt already matching the frame host, update it!
    if (!CGRectEqualToRect(self.frameHost.frame, self.frame))
    [self updateFrame];
  }

  else if ([keyPath isEqualToString:@"image"])
  {
    UIImageView * imageHost = self.imageHost;
    if ([imageHost respondsToSelector:@selector(image)])
    [self updateArtwork:nil];
  }

  else if (self.centerHost && [keyPath isEqualToString:@"center"])
  {
    [self updateCenter];
  }
}

-(void)themeUpdating {
  if (self.currentTheme)
  {
    ((UIImageView *)_containerView.maskView).image = [self maskImage];
    [_overlayView setBackgroundImage:[self overlayImage] forState:UIControlStateNormal];
    [_underlayView setBackgroundImage:[self underlayImage] forState:UIControlStateNormal];

    [self updateFrame];
  }
}

-(void)updateTheme
{
  NSString * ident = self.identifier;
  if (ident)
  {
    NSBundle * currentTheme = [MASQThemeManager themeBundleForKey:ident];
    // HBLogDebug(@"id %@, theme b %@", self.identifier, currentTheme);
    if (currentTheme == self.currentTheme) return;

    self.currentTheme = currentTheme;
    [self themeUpdating];
  }
  else HBLogError(@"There was no identifier?");
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
    self.bounds = self.frameHost.bounds;
    self.center = self.frameHost.center;
    _containerView.maskView.frame = _containerView.frame;
    float ratio = [self ratio];
    // _artworkImageView.frame = _containerView.frame;
    // _artworkImageView.transform = CGAffineTransformMakeScale(ratio, ratio);

    _artworkImageView.bounds = CGRectMake(_containerView.bounds.origin.x,_containerView.bounds.origin.y,self.bounds.size.width * ratio, self.frame.size.height * ratio);
    _artworkImageView.center = _containerView.center;
  } completion:nil];
  if (self.centerHost) [self updateCenter];
}

-(void)updateArtwork:(UIImage *)img
{
  if ([img isKindOfClass:NSClassFromString(@"UIImage")])
  {
    self.hashCache = img.hash;
    self.artworkImageView.image = img;
    return;
  }

  UIImageView * ihost = self.imageHost;
  if (ihost)
  {
    if ([ihost respondsToSelector:@selector(image)])
    {
      UIImage * image = [ihost image];
      // HBLogDebug(@"image  hsh %d", image.hash);
      if (image.hash != self.hashCache)
      {
        // HBLogWarn(@"these have a different cache, so lets update");
        self.hashCache = image.hash;
        self.artworkImageView.image = image;
      }
    }
  }
  else HBLogError(@"imageHost is not type UIImageView, and no UIImage was offered so artwork is NOT being updated, perhaps you will need a different imageHost?");
}

-(void)setImageHost:(id)arg1 {
  _imageHost = arg1;
  if (self.imageHost)
  {
    [self.imageHost addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [self.imageHost addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil]; //maybe track image.hash if i can get it from the object
    [self updateArtwork:nil];
  }
}

-(void)setFrameHost:(id)arg1
{
  _frameHost = arg1;
  if (self.frameHost)
  {
    [self.frameHost addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    self.center = self.frameHost.center;
    [self updateFrame];
  }
}

-(void)setCenterHost:(id)arg1
{
  _centerHost = arg1;
  if (self.centerHost)
  {
    [self.centerHost addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
    self.center = self.centerHost.center;
  }
}

-(float)ratio
{
  NSBundle * cur = self.currentTheme;
  return cur ? [[[[cur bundlePath] lastPathComponent] componentsSeparatedByString:@"@"].lastObject floatValue] / 100 : 1;
}

// layers
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
  [c addSubview:_artworkImageView = [[UIImageView alloc] initWithFrame:self.bounds]];// [c addSubview:[self artworkImageView]];
  return _containerView = c;
}

-(id)underlayView {
  UIButton * u = [[UIButton alloc] initWithFrame:self.bounds];
  u.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; //resize to super width
  u.userInteractionEnabled = NO;
  u.center = self.center;
  return _underlayView = u;
}

-(id)overlayView
{
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
      if (NSClassFromString(@"SBCoverSheetPresentationManager"))
      { // dismiss notification center ios 11.x - 12.x
        SBCoverSheetPresentationManager * nc = [NSClassFromString(@"SBCoverSheetPresentationManager") sharedInstance];
        // BOOL deviceUnlocked = ((SBLockStateAggregator *)[NSClassFromString(@"SBLockStateAggregator") sharedInstance]).lockState == 2;
        // @TODO uhh wtf is this now = 1
        // literally it makes no sense how that could be possible it was legit working with ==2 for so long but idfk

        BOOL deviceUnlocked = ((SBLockStateAggregator *)[NSClassFromString(@"SBLockStateAggregator") sharedInstance]).lockState == 1;
        if (nc.isVisible && deviceUnlocked)
        // if (nc.isVisible)
        [nc setCoverSheetPresented:NO animated:YES withCompletion:nil];
      }

      if (app && [UIApplication.sharedApplication respondsToSelector:@selector(launchApplicationWithIdentifier:suspended:)])
      [UIApplication.sharedApplication launchApplicationWithIdentifier:app.bundleIdentifier suspended:NO];
    }
  }
}

/// images
-(UIImage *)maskImage
{
  return self.currentTheme ?
  [UIImage imageWithContentsOfFile:[self.currentTheme pathForResource:@"Mask" ofType:@"png"]]
  : nil;
}

-(UIImage *)overlayImage
{
  return self.currentTheme ?
  [UIImage imageWithContentsOfFile:[self.currentTheme pathForResource:@"Overlay" ofType:@"png"]]
  : nil;
}

-(UIImage *)underlayImage
{
  return self.currentTheme ?
  [UIImage imageWithContentsOfFile:[self.currentTheme pathForResource:@"Underlay" ofType:@"png"]]
  : nil;
}

/*
// ios 13 exclusive https://developer.apple.com/documentation/mediaplayer/mpnowplayinginfocenter/2588243-playbackstate?language=objc
 20944 ms  -[NSNotificationCenter postNotificationName:_MRMediaRemotePlayerPlaybackStateDidChangeNotification object:0x0 userInfo:0x281694940]
 20947 ms  -[NSNotificationCenter postNotificationName:_kMRMediaRemotePlayerPlaybackStateDidChangeNotification object:0x0 userInfo:0x28169f660]


one has a k, one does not hmm
 _MRMediaRemotePlayerPlaybackStateDidChangeNotification
_kMRMediaRemotePlayerPlaybackStateDidChangeNotification
*/

// -(int)playbackState {
//   if (NSClassFromString(@"SBMediaController"))
//   { // in springboard
//     return SBMediaController.sharedInstance.
//   }
//   else
//   { // in an app
//
//   }
//
//   return 0;
// }

// //rotation shit
// -(void)animate {
//   //check if already animating, if no then add one else resume
//   HBLogWarn(@"Supposed to rotate");
//   [self.artworkImageView rotate360WithDuration:2.0 repeatCount:0];
//   [self.artworkImageView resumeAnimations];
//   enable && themeAssets && [themeBundleName hasPrefix:@"🌀"] && arg2 ? [[self.artworkView valueForKey:@"_artworkImageView"] resumeAnimations] : [[self.artworkView valueForKey:@"_artworkImageView"] pauseAnimations];
//   // }
//
// }
// //
// -(void)pauseIfAnimating {
//   //if active animation > pause else do nothing
// HBLogWarn(@"pause animations");
//   [self.artworkImageView pauseAnimations];
// }
@end
