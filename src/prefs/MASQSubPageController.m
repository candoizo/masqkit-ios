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
	self.navigationController.navigationController.navigationBar.barStyle = 1;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
