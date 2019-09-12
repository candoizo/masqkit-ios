#import "Preferences/PSSpecifier.h"
#import "MASQLocalizer.h"
#import "MASQSubPageController.h"

@implementation MASQSubPageController
- (NSArray *)specifiers {
	if (!_specifiers)	{
		_specifiers = [self loadSpecifiersFromPlistName:[NSString stringWithFormat:@"Prefs/%@", [[self specifier] propertyForKey:@"specs"]] target:self];
		[NSClassFromString(@"MASQLocalizer") parseSpecifiers:_specifiers];
	}
	return _specifiers;
}

-(void)viewWillAppear:(BOOL)arg1 {
	[super viewWillAppear:arg1];

	self.navigationController.navigationController.navigationBar.tintColor = UIColor.whiteColor;
	// self.navigationController.navigationController.navigationBar.barStyle = 0;

	UIView * bg = [self.navigationController.navigationController.navigationBar valueForKey:@"_backgroundView"];

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
	UIView * bgEff = [bg valueForKey:@"_backgroundEffectView"];
	bgEff.alpha = 0;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationController.navigationController.navigationBar.tintColor = nil;
	self.navigationController.navigationController.navigationBar.barTintColor = nil;

	UIView * bg = [self.navigationController.navigationController.navigationBar valueForKey:@"_backgroundView"];

	if ([bg viewWithTag:6969])
	{
		[[bg viewWithTag:6969] removeFromSuperview];
	}

  // [self.navigationController.navigationController.navigationBar _updateNavigationBarItemsForStyle:0];
	self.navigationController.navigationController.navigationBar.barStyle = 0; // woot need this :D
	UIView * bgEff = [bg valueForKey:@"_backgroundEffectView"];
	bgEff.alpha = 1;

	// [UIApplication.sharedApplication setStatusBarStyle:self.origStyle];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
