#import "MASQHeaderView.h"

@implementation MASQHeaderView
-(id)initWithFrame:(CGRect)arg1 tweakTitle:(NSString *)arg2 iconImage:(id)arg3 {
  if (self = [super initWithFrame:arg1]) {
    [self addSubview:[self tweakTitleWithName:arg2]];
    [self addSubview:[self tweakIconWithImage:arg3]];
    [self addSubview:[self creditViewWithText:@"a candoizo production\n\n©hirp ©hirp"]];

  // Set vertical effect
  UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
  verticalMotionEffect.minimumRelativeValue = @(-20);
  verticalMotionEffect.maximumRelativeValue = @(20);

  // Set horizontal effect
  UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
  horizontalMotionEffect.minimumRelativeValue = @(-20);
  horizontalMotionEffect.maximumRelativeValue = @(20);

  // Create group to combine both
  UIMotionEffectGroup *group = [UIMotionEffectGroup new];
  group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];

  // Add both effects to your view
  [self addMotionEffect:group];
  }
  return self;
}

-(UILabel *)tweakTitleWithName:(NSString *)arg1 {
  UILabel *tweakTitle = [[UILabel alloc] initWithFrame:CGRectZero];
  tweakTitle.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:40];
  tweakTitle.text = arg1;
  tweakTitle.textAlignment = 1;
  tweakTitle.textColor = [UIColor.blackColor colorWithAlphaComponent:0.7];
  [tweakTitle sizeToFit];
  tweakTitle.frame = CGRectMake(self.bounds.size.width/2, 0, tweakTitle.bounds.size.width, 43.5);
  tweakTitle.center = CGPointMake(self.bounds.size.width*0.6,self.center.y);
  return tweakTitle;
}

-(UIImageView *)tweakIconWithImage:(id)arg1 {
  CGRect f = CGRectMake(0 ,0, [self smallerBound]/2.5, [self smallerBound]/2.5);
  UIImageView *icon = [[UIImageView alloc] initWithFrame:f];
  icon.clipsToBounds = YES;
  [icon _setContinuousCornerRadius:9];
  icon.image = arg1;
  icon.center = CGPointMake(self.bounds.size.width/3.5,self.center.y);
  return icon;
}

-(float)smallerBound {
  return self.bounds.size.width > self.bounds.size.height ? self.bounds.size.height : self.bounds.size.width;
}

-(UILabel *)creditViewWithText:(NSString *)arg1 {
	UILabel *copyright = [[UILabel alloc] initWithFrame:CGRectMake(0, - 40, self.bounds.size.width, 30)];
	copyright.numberOfLines = 0;
	copyright.font = [UIFont fontWithName:@"HelveticaNeue" size:8];
	copyright.text = arg1;
	copyright.textColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
	copyright.textAlignment = 1;
	return copyright;
}
@end
