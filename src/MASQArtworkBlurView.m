#import "MediaRemote/MediaRemote.h"
#import "MASQArtworkBlurView.h"
#import "MASQThemeManager.h"

@implementation MASQArtworkBlurView
-(id)initWithFrame:(CGRect)arg1 {
  if (self = [super initWithFrame:arg1]) {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    self.hidden = YES;

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateArtwork)  name:@"_kMRMediaRemotePlayerNowPlayingInfoDidChangeNotification" object:nil];

  }
  return self;
}

-(id)initWithFrame:(CGRect)arg1 layer:(CALayer *)arg2 {
  if (self = [super initWithFrame:arg1]) {
    if (arg2.cornerRadius) [self _setContinuousCornerRadius:(arg2.cornerRadius*0.85)];
  }
  return self;
}

-(void)dealloc {
  [NSNotificationCenter.defaultCenter removeObserver:self
    name:@"_kMRMediaRemotePlayerNowPlayingInfoDidChangeNotification" object:nil];
  // [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(UIVisualEffectView *)effectViewWithEffect:(id)arg1 {
   UIVisualEffectView * v = [[UIVisualEffectView alloc] initWithEffect:arg1];
   v.frame = CGRectMake(0,0,self.bounds.size.width, self.bounds.size.height);
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
  UIBlurEffect * eff; switch (style) {
    case 1: eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]; break;
    case 2: eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]; break;
    case 3: eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]; break;
  }

  [self updateArtwork];

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
    [self updateArtwork];
  }
}


-(void)updateArtwork {
  MRMediaRemoteGetNowPlayingInfo( dispatch_get_main_queue(), ^(CFDictionaryRef information) {
    NSDictionary *dict = (__bridge NSDictionary *)(information);
    // since it's blurred we can easily use the low res version
    if ([UIImage imageWithData:dict[@"kMRMediaRemoteNowPlayingInfoArtworkData"]])
    self.image = [UIImage imageWithData:dict[@"kMRMediaRemoteNowPlayingInfoArtworkData"]];
  });
}
@end
