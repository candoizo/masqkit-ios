#import "MASQBaseController.h"
#import "../MASQThemeManager.h"

@implementation MASQBaseController
+(void)clearPrefs {
	[NSUserDefaults.standardUserDefaults removePersistentDomainForName:@"ca.ndoizo.masqkit"];
}

-(UINavigationBar *)bar {
  return self.navigationController.navigationController.navigationBar;
}

-(UIImage *)imageFromBundle:(NSString *)arg1 {
  return [UIImage imageNamed:arg1 inBundle:self.bundle];
}

-(NSArray *)sortRuleByKey:(NSString *)arg1 {
	return @[[NSSortDescriptor sortDescriptorWithKey:arg1 ascending:YES]];
}

-(void)loadView {
  [super loadView];

	self.prefs = [NSClassFromString(@"MASQThemeManager") prefs];
  self.barStyle = UIApplication.sharedApplication.statusBarStyle;
  self.bar.tintColor = UIColor.whiteColor;
}

-(void)viewDidLoad {
  [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)arg1 {
  [super viewWillAppear:arg1];

  [self wantsStyle:YES];
  [self reloadSpecifiers];
}

-(void)viewWillDisappear:(BOOL)arg1 {
  [super viewWillDisappear:arg1];

  UINavigationBar * bar = self.bar;
	bar.titleTextAttributes = nil;
	bar.tintColor = nil;
	bar.barTintColor = nil;

	[self wantsStyle:NO];
}

-(void)wantsStyle:(BOOL)arg1 {
  UINavigationBar * bar = self.bar;
  UIView * bg = [bar valueForKey:@"_backgroundView"];
	if (!bg) return;
	int ver = UIDevice.currentDevice.systemVersion.doubleValue;
  // if (![self isMemberOfClass:NSClassFromString(@"MASQPrefsController")])
  // return;
  if (arg1)
  {
    if (self.barStyle > -1)
    {
      [UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleLightContent];
    }

    // has already been added by another
    if ([bg viewWithTag:6969])
    return;

    bar.tintColor = UIColor.whiteColor;

		if (ver < 13) // not allowed on ios 13
    ((UIView *)[bg valueForKey:@"_backgroundEffectView"]).alpha = 0;

    UIView * myv = [[UIView alloc] initWithFrame:bg.bounds];
    myv.tag = 6969;
    myv.userInteractionEnabled = NO;

		CAGradientLayer *gradient = [NSClassFromString(@"CAGradientLayer") layer];
		gradient.frame = bg.bounds;
		gradient.colors = @[(id)[UIColor colorWithRed:0.29 green:0.64 blue:1.00 alpha:1.0].CGColor, (id)[UIColor colorWithRed:1.00 green:0.29 blue:0.52 alpha:1.0].CGColor];
		gradient.startPoint = CGPointMake(0.0,0.5);
		gradient.endPoint = CGPointMake(1.0,1.0);

		[bg addSubview:myv];
		[myv.layer insertSublayer:gradient atIndex:0];
  }
  else
  { // restore to the original look
    if (self.barStyle > -1)
    {
      [UIApplication.sharedApplication setStatusBarStyle:self.barStyle];
    }

    if ([bg viewWithTag:6969])
    [[bg viewWithTag:6969] removeFromSuperview];

    bar.barStyle = 0;
		if (ver < 13)
    ((UIView *)[bg valueForKey:@"_backgroundEffectView"]).alpha = 1;
  }
}
@end
