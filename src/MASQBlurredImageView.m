#import "MASQBlurredImageView.h"
#import "MASQHousekeeper.h"
#import "MediaRemote/MediaRemote.h"

@implementation MASQBlurredImageView
-(id)initWithFrame:(CGRect)arg1 {
  if (self = [super initWithFrame:arg1]) {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.contentMode = UIViewContentModeScaleAspectFill;
  }
  return self;
}
-(id)initWithFrame:(CGRect)arg1 layer:(CALayer *)arg2 {
  if (self = [super initWithFrame:arg1]) {
    self.clipsToBounds = YES;
    if (arg2.cornerRadius) [self _setContinuousCornerRadius:(arg2.cornerRadius*0.85)];
  }
  return self;
}

-(UIVisualEffectView *)effectViewWithEffect:(id)arg1 {
   UIVisualEffectView * v = [[UIVisualEffectView alloc] initWithEffect:arg1];
   v.frame = CGRectMake(0,0,self.bounds.size.width, self.bounds.size.height);
   v.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   return v;
}

-(void)updateEffectWithKey {
  int style = [[MASQHousekeeper.sharedPrefs valueForKey:self.styleKey] intValue];
  self.alpha = !(style == 0);
  if (style != 0) [self updateEffectWithStyle:style];
}

-(void)updateEffectWithStyle:(int)style {
  // self.hidden = (style == 0); /* maybe don't need but double check */
  UIBlurEffect * eff; switch (style) {
    case 1: eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]; break;
    case 2: eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]; break;
    case 3: eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]; break;
  }
  if (eff) {
    [self.effectView removeFromSuperview];
    self.effectView = [self effectViewWithEffect:eff];
    [self addSubview:self.effectView];
  }
}

-(void)loadArtwork {
  MRMediaRemoteGetNowPlayingInfo( dispatch_get_main_queue(), ^(CFDictionaryRef information) {
  NSDictionary *dict = (__bridge NSDictionary *)(information);
  if ([UIImage imageWithData:dict[@"kMRMediaRemoteNowPlayingInfoArtworkData"]])
  self.image = [UIImage imageWithData:dict[@"kMRMediaRemoteNowPlayingInfoArtworkData"]];
  });
}
@end
