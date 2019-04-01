#import "MASQArtworkView.h"
#import "MASQHousekeeper.h"
#import "MASQThemeManager.h"
#import "MASQMediaStateManager.h"

#define _c(c) NSClassFromString(c)
#define arrayContainsKindOfClass(a, c) [a filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self isKindOfClass: %@", c]]

@implementation MASQArtworkView
-(id)initWithThemeKey:(NSString *)key
{
  if (self = [super init])
  {
    [self addSubview:[self underlayView]];
    [self addSubview:[self containerView]];
    [self addSubview:[self overlayView]];
    _identifier = key;
    [self updateTheme];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateTheme)  name:UIApplicationDidBecomeActiveNotification object:nil];
  }
  return self;
}

-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self
    name:UIApplicationDidBecomeActiveNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
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

  // if ([MASQThemeManager themeBundleForKey:self.identifier] != self.currentTheme)
  // [self updateTheme];

  if ([keyPath isEqualToString:@"frame"])
  {
    // if ours isnt already matching the frame host, update it!
    if (!CGRectEqualToRect(self.frameHost.frame, self.frame))
    [self updateFrame];
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
    // unset the scale so when we change it isnt messed
    // _artworkImageView.transform = CGAffineTransformMakeScale(1, 1);
    ((UIImageView *)_containerView.maskView).image = [self maskImage];
    [_overlayView setBackgroundImage:[self overlayImage] forState:UIControlStateNormal];
    [_underlayView setBackgroundImage:[self underlayImage] forState:UIControlStateNormal];

    // fixup the artwork scale by updating hte frame
    [self updateFrame];
    // float ratio = [self ratio];
    // _artworkImageView.transform = CGAffineTransformMakeScale(ratio, ratio);
  }
}

-(void)updateTheme
{
  if (self.identifier)
  {
    NSBundle * currentTheme = [MASQThemeManager themeBundleForKey:self.identifier];
    HBLogDebug(@"id %@, theme b %@", self.identifier, currentTheme);
    if (currentTheme == self.currentTheme) return;

    self.currentTheme = currentTheme;
    [self themeUpdating];
  }
}

-(void)updateFrame
{
  [UIView animateWithDuration:0/*CGRectEqualToRect(self.frame, CGRectZero) ? 0 : 0.3*/ animations:^
  {
    self.bounds = self.frameHost.bounds;
    self.center = self.frameHost.center;
    _containerView.maskView.frame = _containerView.frame;
    float ratio = [self ratio];
    // _artworkImageView.frame = _containerView.frame;
    // _artworkImageView.transform = CGAffineTransformMakeScale(ratio, ratio);

    _artworkImageView.bounds = CGRectMake(_containerView.bounds.origin.x,_containerView.bounds.origin.y,self.bounds.size.width * ratio, self.frame.size.height * ratio);
    _artworkImageView.center = _containerView.center;
  } completion:nil];
}

-(void)updateArtwork:(UIImage *)img
{
  if ([img isKindOfClass:_c(@"UIImage")]) self.artworkImageView.image = img;
  else if ([self.imageHost isKindOfClass:_c(@"UIImageView")])
  self.artworkImageView.image = self.imageHost.image;
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
  if ([UIApplication.sharedApplication respondsToSelector:@selector(launchApplicationWithIdentifier:suspended:)])
  [UIApplication.sharedApplication launchApplicationWithIdentifier:MASQMediaStateManager.playerBundleID suspended:NO];
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
@end
