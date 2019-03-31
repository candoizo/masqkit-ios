#import "MASQArtworkView.h"
#import "MASQHousekeeper.h"
#import "MASQThemeManager.h"
#import "MASQMediaStateManager.h"

#define _c(c) NSClassFromString(c)

@implementation MASQArtworkView
-(id)initWithThemeKey:(NSString *)key {
    if (self = [super init]) {
     [self addSubview:[self underlayView]];
     [self addSubview:[self containerView]];
     [self addSubview:[self overlayView]];
      _identifier = key;
      [self updateTheme];
    }
  return self;
}

-(id)initWithThemeKey:(NSString *)arg1 frameHost:(id)arg2 imageHost:(id)arg3 {
  if (self = [self initWithThemeKey:arg1]) {
    self.frameHost = arg2;
    self.imageHost = arg3;
  }
  return self;
}

-(void)wantsHostsVisible:(BOOL)arg1 {
  self.imageHost.hidden = !arg1;
  self.imageHost.alpha = arg1;
}

#define arrayContainsKindOfClass(a, c) [a filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self isKindOfClass: %@", c]]

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  // UIView * frameHost = self.frameHost;
  if (self.disabled)
  {
    // opposite visibility
    [self wantsHostsVisible:YES];
    return; //exit because we're disabled so theres nothing to do
  }
  // if not disabled, lets check that the themes match & update if not
  if ([MASQThemeManager themeBundleForKey:self.identifier] != self.currentTheme)
  [self updateTheme];

  // perhaps I could put the wantsHostsVisible part here

  if ([keyPath isEqualToString:@"frame"])
  { //if the frames of our host change
    // if ours isnt already matching the frame host, update it!
    if (!CGRectEqualToRect(self.frameHost.frame, self.frame)) [self updateFrame];

    //since we arent disabled, we should call stuff to hide our image host
    // also maybe this can be called before the If "frame"
    [self wantsHostsVisible:NO];

  }

  else if ([keyPath isEqualToString:@"image"] && !self.usesDirectImage)
  {
    UIImageView * imageHost = self.imageHost;
    if (imageHost.image.hash != self.hashCache)
    {
      self.hashCache = imageHost.image.hash;
      [self updateArtwork:imageHost.image];
    }
  }
}

-(void)themeUpdating {
  if (self.currentTheme)
  {
    ((UIImageView *)_containerView.maskView).image = [self maskImage];
    [_overlayView setBackgroundImage:[self overlayImage] forState:UIControlStateNormal];
    [_underlayView setBackgroundImage:[self underlayImage] forState:UIControlStateNormal];
    float ratio = [self ratio];
    _artworkImageView.transform = CGAffineTransformMakeScale(ratio, ratio);
  }
}

-(void)forceDisable {
  if (self.disabled)
  {
    self.currentTheme = nil;
    HBLogDebug(@"updateTheme\n self.disabled = YES, setting shit visible");
    ((UIImageView *)_containerView.maskView).image = nil;
    [_overlayView setBackgroundImage:nil forState:UIControlStateNormal];
    [_underlayView setBackgroundImage:nil forState:UIControlStateNormal];
    self.imageHost.alpha = 1;
    self.imageHost.hidden = NO;
    self.frameHost.alpha  = 1;
    self.frameHost.hidden = NO;
  }
}

-(void)updateTheme {
  if (self.identifier)
  {
    NSBundle * currentTheme = [MASQThemeManager themeBundleForKey:self.identifier];
    HBLogDebug(@"id %@, theme b %@", self.identifier, currentTheme);
    if (currentTheme == self.currentTheme) return;

    if ([[currentTheme.bundlePath lastPathComponent] isEqualToString:@"Disabled"] || !currentTheme)
    {
      HBLogDebug(@"No theme chosen? %@", currentTheme);
      self.currentTheme = nil;
      self.disabled = YES;
      [self forceDisable];
      return;
    }
    // must have chosen a theme
    if (self.disabled) self.disabled = NO;
    self.currentTheme = currentTheme;
    [self themeUpdating];
  }
}

-(void)updateFrame {
  float ratio = [self ratio];
  [UIView animateWithDuration:0/*CGRectEqualToRect(self.frame, CGRectZero) ? 0 : 0.3*/ animations:^
  {
    self.bounds = self.frameHost.bounds;
    self.center = self.frameHost.center;
    _containerView.maskView.frame = _containerView.frame;
    _artworkImageView.frame = _containerView.frame;
    _artworkImageView.transform = CGAffineTransformMakeScale(ratio, ratio);

  } completion:nil];
}

-(void)updateArtwork:(UIImage *)img {
  HBLogDebug(@"arg1: %@", img);
  if ([img isKindOfClass:_c(@"UIImage")]) self.artworkImageView.image = img;
  else if ([self.imageHost isKindOfClass:_c(@"UIImageView")]) self.artworkImageView.image = self.imageHost.image;
  else HBLogError(@"imageHost is not type UIImageView, and no UIImage was offered so artwork is NOT being updated, perhaps you will need a different imageHost?");
}

-(void)setImageHost:(id)arg1 {
  _imageHost = arg1;
  if (self.imageHost) {
    [self.imageHost addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [self.imageHost addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil]; //maybe track image.hash if i can get it from the object
    [self updateArtwork:nil];
  }
}

-(void)setFrameHost:(id)arg1 {
  _frameHost = arg1;
  if (self.frameHost) {
   [self.frameHost addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
   self.center = self.frameHost.center;
   [self updateFrame];
 }
}

-(float)ratio {
   return self.currentTheme ? [[[[self.currentTheme bundlePath] lastPathComponent] componentsSeparatedByString:@"@"].lastObject floatValue] / 100 : 1;
}

// layers
-(id)containerView {
   UIView * c = [[UIView alloc] initWithFrame:self.bounds];
   c.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; //resize to super width
   c.center = self.center;

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

-(void)tapArtwork:(id)sender {
  if (NSClassFromString(@"SBMediaController") && [UIApplication.sharedApplication respondsToSelector:@selector(launchApplicationWithIdentifier:suspended:)])
  [UIApplication.sharedApplication launchApplicationWithIdentifier:MASQMediaStateManager.playerBundleID suspended:NO];
}

/// images
-(UIImage *)maskImage {
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
@end
