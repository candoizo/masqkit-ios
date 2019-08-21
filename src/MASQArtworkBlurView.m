#import "MediaRemote/MediaRemote.h"
#import "MASQArtworkBlurView.h"
#import "MASQThemeManager.h"

@interface SBMediaController : NSObject
+(SBMediaController *)sharedInstance;
-(BOOL)hasTrack;
@end

@implementation MASQArtworkBlurView
-(void)dealloc {
  [NSNotificationCenter.defaultCenter removeObserver:self
    name:@"_kMRMediaRemotePlayerNowPlayingInfoDidChangeNotification" object:nil];
}

-(id)initWithFrame:(CGRect)arg1 {
  if (self = [super initWithFrame:arg1]) {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    self.hidden = YES;

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateArtwork:)  name:@"_kMRMediaRemotePlayerNowPlayingInfoDidChangeNotification" object:nil];
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

-(void)updateEffectWithKey {

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
    [self updateEffectWithKey];
    [self updateArtwork:nil];
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

  if ([keyPath isEqualToString:@"image"])
  {
    UIImageView * imageHost = self.imageHost;
    if ([imageHost respondsToSelector:@selector(image)])
    [self updateArtwork:nil];
  }

  else if ([keyPath isEqualToString:@"frame"])
  {
      [self updateVisibility];
  }
}

-(void)updateArtwork:(id)arg1 {

  if ([arg1 isKindOfClass:NSClassFromString(@"UIImage")]) // supply image
  {
    self.image = arg1;
  }
  else if (self.imageHost.image)
  {
    self.image = self.imageHost.image;
  }

  else
  MRMediaRemoteGetNowPlayingInfo( dispatch_get_main_queue(), ^(CFDictionaryRef information) {
    NSDictionary *dict = (__bridge NSDictionary *)(information);
    // since it's blurred we can easily use the low res version
    UIImage * img = [UIImage imageWithData:dict[@"kMRMediaRemoteNowPlayingInfoArtworkData"]];
    if (img)
    self.image = img;
  });
}

-(void)updateVisibility {

  if (self.identifier)
  {
    NSString * key = [NSString stringWithFormat:@"%@.style", self.identifier];
    int style = [[MASQThemeManager.prefs valueForKey:key] intValue];
    self.alpha = !(style == 0) && [NSClassFromString(@"SBMediaController") sharedInstance].hasTrack;
    self.hidden = style == 0 && ![NSClassFromString(@"SBMediaController") sharedInstance].hasTrack;
  }
}
@end
