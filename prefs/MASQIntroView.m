#import "MASQIntroView.h"
#import "../src/MASQThemeManager.h"

static NSString * const kWelcome = @"Welcome to MASQ²";
static NSString * const kDesc = @"A powerful music aesthetic enhancer for iOS!";
static NSString * const kSectionOne = @"Customize your look with creative themes from amazing designers";
static NSString * const kSectionTwo = @"Peep your music at it's best without compromising performance";
static NSString * const kSectionThree = @"Plugins let you bring the experience everywhere";

@implementation MASQIntroView
-(id)init {
  if (self = [super initWithFrame:UIScreen.mainScreen.bounds]) {
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];

    [self addSubview:[self welcomeLabel]];
    [self addSubview:[self descriptionLabel]];
    [self addSubview:[self viewForSection:1]];
    [self addSubview:[self viewForSection:2]];
    [self addSubview:[self viewForSection:3]];
    [self addSubview:[self continueButton]];
  }
  return self;
}

-(id)viewForSection:(int)arg1 {
  UIView * section = nil;
  if (arg1 == 1) {
  section = [self sectionWithImage:nil text:kSectionOne];
  section.center = CGPointMake(self.center.x, self.bounds.size.height * 0.4);
  }
  else if (arg1 == 2) {
  section = [self sectionWithImage:nil text:kSectionTwo];
  section.center = CGPointMake(self.center.x, self.bounds.size.height * 0.55);
  }
  else if (arg1 == 3) {
  section = [self sectionWithImage:nil text:kSectionThree];
  section.center = CGPointMake(self.center.x, self.bounds.size.height * 0.7);
  }
  return section;
}

-(id)sectionWithImage:(UIImage *)arg1 text:(NSString *)arg2 {
  UIView * sec = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.bounds.size.width*0.75, self.bounds.size.width/4)];

  if (arg1) {
    UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0 ,sec.bounds.size.height/1.82, sec.bounds.size.height/1.82)];
    iv.image = arg1;
    iv.center = sec.center;
    [sec addSubview:iv];
  }

  if (arg2) {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,sec.frame.size.width/2, sec.frame.size.height)];
  	label.font = [label.font fontWithSize:14];
  	label.textColor = [UIColor.blackColor colorWithAlphaComponent:0.55];
  	label.numberOfLines = 0;
  	label.text = arg2;
    label.center = sec.center;
    [sec addSubview:label];
  }
  return sec;
}

-(id)welcomeLabel {
  CGRect f = CGRectMake(0, self.bounds.size.height/7, self.bounds.size.width, 30);
  UILabel * welcome = [[UILabel alloc] initWithFrame:f];
	welcome.font = [UIFont fontWithName:@".SFUIDisplay-Light" size:28];
	welcome.textColor = [UIColor.blackColor colorWithAlphaComponent:0.8];
	welcome.textAlignment = 1;
	welcome.text = kWelcome;
  return welcome;
}

-(id)descriptionLabel {
  UILabel * desc = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height/5, self.bounds.size.width/1.5, 50)];
  desc.adjustsFontSizeToFitWidth = YES;
  desc.minimumFontSize = 10.0;
  desc.numberOfLines = 0;
  desc.font = [UIFont fontWithName:@".SFUIText" size:14];
  desc.center = CGPointMake(self.center.x, desc.center.y);
  desc.textColor = [UIColor.blackColor colorWithAlphaComponent:0.75];
  desc.textAlignment = 1;
  desc.text = kDesc;
  return desc;
}

-(id)continueButton {
  UIButton * cont = [[UIButton alloc] initWithFrame:CGRectMake(0, self.bounds.size.height *0.85, self.bounds.size.width/1.4 , self.bounds.size.width/8)];
	cont.backgroundColor = [UIColor colorWithRed:0.87 green:0.25 blue:0.40 alpha:1.0];
	cont.layer.masksToBounds = YES;
	cont.layer.cornerRadius = 10;
	cont.center = CGPointMake(self.center.x, cont.center.y);
	[cont setTitle: @"Continue" forState:UIControlStateNormal];
	[cont addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
  return cont;
}

-(void)dismiss {
	[[NSClassFromString(@"MASQThemeManager") sharedPrefs] setBool:YES forKey:@"firstTime"];
	 [UIView animateWithDuration:.35 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
				self.alpha = 0;
			}  completion:^(BOOL finished) {
				  if (finished) [self removeFromSuperview];
			}
	 ];
}
@end
