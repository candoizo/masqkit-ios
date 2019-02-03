#import "MASQArtworkView.h"
#import "MASQHousekeeper.h"

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

-(void)updateTheme {
  if (self.identifier) {
        NSString * theme = [[_c(@"MASQHousekeeper") sharedPrefs] valueForKey:self.identifier];
        if (!theme) { //maybe sandboxed
          NSString *plistPath = [[NSBundle bundleWithPath:@"/private/var/mobile/Library/Preferences/"] pathForResource:@"ca.ndoizo.masq" ofType:@"plist"];
          theme = [NSDictionary dictionaryWithContentsOfFile:plistPath][self.identifier];
        }
        if (self.disabled && self.currentTheme) {
          self.currentTheme = nil;
          HBLogDebug(@"updateTheme\n self.disabled = YES, setting shit visible");
          ((UIImageView *)_containerView.maskView).image = nil;
          [_overlayView setBackgroundImage:nil forState:UIControlStateNormal];
          [_underlayView setBackgroundImage:nil forState:UIControlStateNormal];
          self.imageHost.alpha = 1;
          self.imageHost.hidden = NO;
          self.frameHost.alpha  = 1;
          self.frameHost.hidden = NO;
          return;
        }
        self.currentTheme = [NSBundle bundleWithURL:[[self themePath] URLByAppendingPathComponent:theme]];
        if (self.currentTheme) {
            ((UIImageView *)_containerView.maskView).image = [self maskImage];
            [_overlayView setBackgroundImage:[self overlayImage] forState:UIControlStateNormal];
            [_underlayView setBackgroundImage:[self underlayImage] forState:UIControlStateNormal];
        }
        else HBLogError(@"Could not apply theme, does the themeKey hold a theme value that matches an existing theme? %@ ", theme);
  }
  else HBLogError(@"A themeKey was not supplied, please refer to documentation.");
}

-(void)updateFrame {
  if (self.frameHost.bounds.size.width >= UIScreen.mainScreen.bounds.size.width || self.frameHost.bounds.size.width >= UIScreen.mainScreen.bounds.size.height) {
     HBLogWarn(@"width of artwork view is bigger than screen, arbitrarily centering.");
     [UIView animateWithDuration:0/*CGRectEqualToRect(self.frame, CGRectZero) ? 0 : 0.3*/ animations:^{
        self.bounds = CGRectMake(0,0,self.frameHost.bounds.size.width/1.5,self.frameHost.bounds.size.width/1.5);
        self.center = CGPointMake(UIScreen.mainScreen.bounds.size.width/2, self.frameHost.center.y-100);
        self.containerView.maskView.frame = _containerView.frame;
        self.artworkImageView.bounds = CGRectMake(_containerView.bounds.origin.x,_containerView.bounds.origin.y,self.bounds.size.width * [self ratio], self.frame.size.height * [self ratio]);
        self.artworkImageView.center = _containerView.center;
      } completion:nil];
  } else {
      [UIView animateWithDuration:0/*CGRectEqualToRect(self.frame, CGRectZero) ? 0 : 0.3*/ animations:^{
        self.bounds = self.frameHost.bounds;
        self.center = self.frameHost.center;
        _containerView.maskView.frame = _containerView.frame;
        _artworkImageView.bounds = CGRectMake(_containerView.bounds.origin.x,_containerView.bounds.origin.y,self.bounds.size.width * [self ratio], self.frame.size.height * [self ratio]);
        _artworkImageView.center = _containerView.center;
      } completion:nil];
  }
}

-(void)updateArtwork:(UIImage *)img {
    if ([img isKindOfClass:_c(@"UIImage")]) self.artworkImageView.image = img;
    else if ([self.imageHost isKindOfClass:_c(@"UIImageView")]) self.artworkImageView.image = self.imageHost.image;
    else HBLogError(@"imageHost is not type UIImageView, and no UIImage was offered so artwork was NOT updated.");
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

#define arrayContainsKindOfClass(a, c) [a filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self isKindOfClass: %@", c]]

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

  BOOL updated = [self themeUpdated];
  HBLogDebug(@"Was the theme updated ? %@ \n\nSet theme name is %@ \nRequested theme name for value is %@", updated ? @"YES" : @"NO", self.currentTheme.resourcePath.lastPathComponent, [MASQHousekeeper.sharedPrefs valueForKey:self.identifier]);
  if (updated) [self updateTheme];
  if (self.disabled) return;

  if ([keyPath isEqualToString:@"frame"]) {
    if (!CGRectEqualToRect(self.frameHost.frame, self.frame)) [self updateFrame];

    //should keep the original imageHost hidden
    if (self.imageHost) {
      self.imageHost.hidden = YES;
      self.imageHost.alpha = 0;

      //if the frame contains our masq artwork, the frameHost cannot be obscured and requires special attention
      if (!arrayContainsKindOfClass(self.frameHost.subviews, self.class)) {
        self.frameHost.hidden = YES;
        self.frameHost.alpha = 0;
      }
    }
  }

  else if ([keyPath isEqualToString:@"image"]) {
      if (self.imageHost.image.hash != self.hashCache) {
        self.hashCache = self.imageHost.image.hash;
        [self updateArtwork:self.imageHost.image];
    }
  }
}

-(NSURL *)themePath {
   return [NSURL fileURLWithPath:@"/Library/Application Support/MASQ/Themes"];
}

-(float)ratio {
   return self.currentTheme ? [[[[self.currentTheme bundlePath] lastPathComponent] componentsSeparatedByString:@"@"].lastObject floatValue] / 100 : 1;
}

-(BOOL)themeUpdated {
  NSString * theme = [MASQHousekeeper.sharedPrefs valueForKey:self.identifier];
  self.disabled = [theme hasPrefix:@"Disabled"];
  return ![self.currentTheme.resourcePath.lastPathComponent isEqualToString:theme];
}

-(void)tapArtwork:(id)sender {
  if (_c(@"SBMediaController"))
  [UIApplication.sharedApplication launchApplicationWithIdentifier:[_c(@"SBMediaController") sharedInstance].nowPlayingApplication.bundleIdentifier suspended:NO];
  else return;
}

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

-(id)overlayView {
   _overlayView = [[UIButton alloc] initWithFrame:self.bounds];
   [_overlayView addTarget:self action:@selector(tapArtwork:) forControlEvents:UIControlEventTouchUpInside];
   _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; //resize to super width
   _overlayView.center = self.center;
   return _overlayView;
}

-(id)underlayView {
   UIButton * u = [[UIButton alloc] initWithFrame:self.bounds];
   u.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; //resize to super width
   u.center = self.center;
   return _underlayView = u;
}

-(UIImage *)maskImage {
   return self.currentTheme ? [UIImage imageWithContentsOfFile:[self.currentTheme pathForResource:@"Mask" ofType:@"png"]] : nil;
}

-(UIImage *)overlayImage {
   return self.currentTheme ? [UIImage imageWithContentsOfFile:[self.currentTheme pathForResource:@"Overlay" ofType:@"png"]] : nil;
}

-(UIImage *)underlayImage {
   return self.currentTheme ? [UIImage imageWithContentsOfFile:[self.currentTheme pathForResource:@"Underlay" ofType:@"png"]] : nil;
}
@end
