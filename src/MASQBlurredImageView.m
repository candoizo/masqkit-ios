#import "MASQBlurredImageView.h"
#import "MASQThemeManager.h"

@implementation MASQBlurredImageView
-(id)initWithFrame:(CGRect)arg1 layer:(CALayer *)arg2 {
  if (self = [super initWithFrame:arg1]) {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.layer.cornerRadius = arg2.cornerRadius;
  }
  return self;
}

-(UIVisualEffectView *)effectViewWithEffect:(id)arg1 {
   UIVisualEffectView * v = [[UIVisualEffectView alloc] initWithEffect:arg1];
   v.bounds = self.bounds;
   v.center = self.center;
   v.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   return v;
}

-(void)updateEffectWithKey {
  [self updateEffectWithStyle:[[MASQThemeManager.sharedPrefs valueForKey:self.styleKey] intValue]];
}

-(void)updateEffectWithStyle:(int)style {
  UIBlurEffect * eff; switch (style) {
    case 1: eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]; break;
    case 2: eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]; break;
    case 3: eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]; break;
  }

  // NSMutableArray * otemp = [self.effectView.contentView.subviews mutableCopy];
  // [self.effectView.contentView.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self removeFromSuperview"]];
  NSMutableArray * temp;
     for (id view in self.effectView.contentView.subviews) {
        [temp addObject:view];
        [view removeFromSuperview];
     }
  [self.effectView removeFromSuperview];
  self.effectView = [self effectViewWithEffect:eff];
  for (id view in temp) {
      [self.effectView.contentView addSubview:view];
  }
  [self addSubview:self.effectView];
}
@end
