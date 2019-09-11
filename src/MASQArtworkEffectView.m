#import "MediaRemote/MediaRemote.h"
#import "MASQArtworkEffectView.h"
#import "MASQThemeManager.h"

/*

  9013 ms  -[MRNotificationClient postNotification:0x28269e080 userInfo:0x2826b4740 object:0x0]
  9013 ms     | -[MRNotificationClient _postNotification:0x28269e080 userInfo:0x2826b4740 object:0x0 withHandler:0x1c7787fc0]
  9014 ms     |    | -[NSNotificationCenter postNotificationName:0x28269e080 object:0x0 userInfo:0x2832d7bc0]
  9014 ms     |    |    | -[MRNotificationClient postNotification:0x1c7792bf8 userInfo:0x2832d7bc0 object:0x0]
  9014 ms     |    |    |    | -[MRNotificationClient _postNotification:0x1c7792bf8 userInfo:0x2832d7bc0 object:0x0 withHandler:0x1c7787fc0]
  9014 ms     |    |    |    |    | -[NSNotificationCenter postNotificationName:0x1c7792bf8 object:0x0 userInfo:0x2836a3780]
  9014 ms     |    |    | -[MRNotificationClient postNotification:0x1c7792bd8 userInfo:0x2832d7bc0 object:0x0]
  9014 ms     |    |    |    | -[MRNotificationClient _postNotification:0x1c7792bd8 userInfo:0x2832d7bc0 object:0x0 withHandler:0x1c7787fc0]
  9019 ms     |    |    |    |    | -[NSNotificationCenter postNotificationName:0x1c7792bd8 object:0x0 userInfo:0x2836fd200]

*/

@implementation MASQArtworkEffectView
-(void)dealloc {
  [NSNotificationCenter.defaultCenter removeObserver:self
    name:@"_kMRMediaRemotePlayerNowPlayingInfoDidChangeNotification" object:nil];
}

-(id)init
{
  if (self = [super init])
  {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        self.hidden = YES;

        // i dont think this actually registers....
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateArtwork:)  name:@"_kMRMediaRemotePlayerNowPlayingInfoDidChangeNotification" object:nil];
  }
  return self;
}

-(id)initWithFrameHost:(UIView *)arg1 radiusHost:(id)arg2 imageHost:(id)arg3
{
  if (self = [self init]) {
    if (arg1)
    self.frameHost = arg1;
    if (arg2)
    self.radiusHost = arg2;
    if (arg3)
    self.imageHost = arg3;
  }
  return self;
}

-(UIVisualEffectView *)effectViewWithEffect:(id)arg1 {
   UIVisualEffectView * v = [[UIVisualEffectView alloc] initWithEffect:arg1];
   v.frame = CGRectMake(0,0,self.bounds.size.width, self.bounds.size.height);
   v.contentMode = UIViewContentModeScaleAspectFill;
   v.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   return v;
}

-(void)updateEffect {

  NSString * key = [NSString stringWithFormat:@"%@.style", self.identifier];
  int style = [MASQThemeManager.prefs integerForKey:key];

  self.alpha = !(style == 0);
  self.hidden = style == 0;
  [self updateEffectWithStyle:style];
}

-(void)updateEffectWithStyle:(int)style {
  // self.hidden = (style == 0); /* maybe don't need but double check */

  // if the current style matches the requested, do nothing?
  // UIVisualEffectView * effect = self.effectView;
  // int blurStyle = effect.effect._style;
  // if (style == blurStyle)
  // return;

  UIBlurEffect * eff; switch (style) {
    case 1: eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]; break;
    case 2: eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]; break;
    case 3: eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]; break;
  }

  [self updateArtwork:nil];

  if (eff) {
    [self.effectView removeFromSuperview];
    self.effectView = [self effectViewWithEffect:eff];
    [self addSubview:self.effectView];
  }
}

-(void)setIdentifier:(NSString *)arg1 {
  _identifier = arg1;

  if (arg1)
  {
    [self updateEffect];
    [self updateArtwork:nil];
  }
}

-(void)setFrameHost:(id)arg1 {
  _frameHost = arg1;
  if (self.frameHost)
  {
    [self.frameHost addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
  }
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

-(void)setRadiusHost:(id)arg1 {
  _radiusHost = arg1;

  [self updateRadius];
}

-(double)cornerRadius {
  id radiusHost = self.radiusHost;
  if (radiusHost)
  { // 0.8 because we want leeway fir non-continuous corners
  //
    if ([radiusHost respondsToSelector:@selector(_continuousCornerRadius)])
    { // MRPlatterViewController for example, or a UIView
      // MRPlatterViewController needs 0.5 because it gets smol
      int radValue = [[radiusHost valueForKey:@"_continuousCornerRadius"] intValue];
      if (radValue > 0)
      return radValue * 0.5;
    }

    if ([radiusHost respondsToSelector:@selector(layer)])
    {
      UIView * v = radiusHost;
      if (v.layer.maskedCorners != 0)
      return v.layer.maskedCorners * 0.8;

      if (v.layer.cornerRadius != 0)
      return v.layer.cornerRadius * 0.8;
    }
  }

  return 0;
}

-(void)updateRadius {
  if (self.radiusHost)
  {
    [self _setContinuousCornerRadius:self.cornerRadius];
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

  if ([keyPath isEqualToString:@"image"])
  {
    if ([self.imageHost respondsToSelector:@selector(image)])
    [self updateArtwork:nil];

    [self updateRadius];
  }

  else if ([keyPath isEqualToString:@"frame"])
  {
    // should it be update corners?
    [self updateRadius];
    [self updateVisibility];
  }
}

-(void)updateArtwork:(id)arg1 {

  if ([arg1 isKindOfClass:NSClassFromString(@"UIImage")])
  { // supply UIImage
    self.image = arg1;
  }
  else if (self.imageHost.image)
  { // has imageHost
    self.image = self.imageHost.image;
  }

  else // no suitable found so fall back on low-res version
  MRMediaRemoteGetNowPlayingInfo(
    dispatch_get_main_queue(), ^(CFDictionaryRef information) {

      NSDictionary *dict = (__bridge NSDictionary *)(information);
      UIImage * img = [UIImage imageWithData:dict[@"kMRMediaRemoteNowPlayingInfoArtworkData"]];
      if (img)
      self.image = img;
    }
  );
}

-(void)updateVisibility {

  if (self.identifier)
  {
    NSString * key = [NSString stringWithFormat:@"%@.style", self.identifier];
    int style = [MASQThemeManager.prefs integerForKey:key];
    if (!NSClassFromString(@"SBMediaController")) return;

    BOOL hasTrack = ((SBMediaController *)[NSClassFromString(@"SBMediaController") sharedInstance]).hasTrack;
    self.alpha = !(style == 0) && hasTrack;
    self.hidden = style == 0 && !hasTrack;
  }
}

@end
