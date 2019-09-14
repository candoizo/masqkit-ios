#import "MASQPrefsController.h"
#import "MASQLocalizer.h"
#import "MASQIntroView.h"
#import "MASQHeaderView.h"
#import "../MASQThemeManager.h"


@implementation MASQPrefsController
- (NSArray *)specifiers {

	if (!_specifiers)
	{ // first load, build the parent page
		NSMutableArray * root = [[self loadSpecifiersFromPlistName:@"Root" target:self] mutableCopy];

		// gathering installed extension prefs
		NSMutableArray * subprefs = [self buildForeignPrefs];
		subprefs.count > 0 ? [root addObjectsFromArray:subprefs] : [self popMissingAlert];

		_specifiers = root;
		[NSClassFromString(@"MASQLocalizer") parseSpecifiers:_specifiers];
	}
	return _specifiers;
}

-(NSString *)pluginPreferencePath {
	return [NSString stringWithFormat:@"%@/Prefs/", self.bundle.bundlePath];
}

-(NSMutableArray *)buildForeignPrefs {

	NSString * path = [self pluginPreferencePath];
	NSMutableArray * plugins = [NSMutableArray new];

	for (NSString * list in [NSFileManager.defaultManager contentsOfDirectoryAtPath:path error:nil])
	{
		if (![list hasSuffix:@"page.plist"])
		{ // if not the speicifer page then it should be a parent cell
			NSString * plist = [NSString stringWithFormat:@"Prefs/%@", [list stringByDeletingPathExtension]];
			NSArray * pluginSpecs = [self loadSpecifiersFromPlistName:plist target:self];
			[plugins addObjectsFromArray:pluginSpecs];
		}
	}

	if (plugins.count > 1)
	[plugins sortUsingDescriptors:[self sortRuleByKey:@"name"]];

	return plugins;
}

-(void)popMissingAlert {
	UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"No Extensions!"
	message:@"MASQKit found no extensions installed on your device, and therefore has no options to offer you, yet: \n\n https://ndoizo.ca ← Add the repo to find some (and download a theme bundle while you're there)!"
	preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction* cancel = [NSClassFromString(@"UIAlertAction") actionWithTitle:@"Dismiss" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action)
	{
		[alert dismissViewControllerAnimated:YES completion:nil];
	}];

	UIAlertAction* repo = [NSClassFromString(@"UIAlertAction") actionWithTitle:@"Open in Cydia" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action)
	{
		[UIApplication.sharedApplication openURL:[NSURL URLWithString:@"cydia://url/https://cydia.saurik.com/api/share#?source=https://ndoizo.ca"]];
	}];

	[alert addAction:repo];
	[alert addAction:cancel];
	[self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[self prepareBar];
}

// - (void)viewWillAppear:(BOOL)animated {
// 	[super viewWillAppear:animated];
//
// 	[self wantsStyle:YES];
// 	[self reloadSpecifiers];
// }

// - (void)viewWillDisappear:(BOOL)animated {
// 	[super viewWillDisappear:animated];
// 	self.navigationController.navigationController.navigationBar.titleTextAttributes = nil;
// 	self.navigationController.navigationController.navigationBar.tintColor = nil;
// 	self.navigationController.navigationController.navigationBar.barTintColor = nil;
//
// 	[self wantsStyle:NO];
// }

// -(void)wantsStyle:(BOOL)arg1
// {
// 	if (arg1)
// 	{ // adding it to the header
// 		if (!self.barStyle)
// 		{
// 			self.barStyle = UIApplication.sharedApplication.statusBarStyle;
// 			[UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleLightContent];
// 		}
// 		self.navigationController.navigationController.navigationBar.tintColor = UIColor.whiteColor;
//
//
// 		UIView * bg = [self.navigationController.navigationController.navigationBar valueForKey:@"_backgroundView"];
//
// 		UIView * myv = [[UIView alloc] initWithFrame:bg.bounds];
// 		myv.tag = 6969;
// 		myv.userInteractionEnabled = NO;
//
// 		CAGradientLayer *gradient = [NSClassFromString(@"CAGradientLayer") layer];
// 		gradient.frame = bg.bounds;
// 		gradient.colors = @[(id)[UIColor colorWithRed:0.29 green:0.64 blue:1.00 alpha:1.0].CGColor, (id)[UIColor colorWithRed:1.00 green:0.29 blue:0.52 alpha:1.0].CGColor];
// 		gradient.startPoint = CGPointMake(0.0,0.5);
// 		gradient.endPoint = CGPointMake(1.0,1.0);
//
// 		[bg addSubview:myv];
// 		[myv.layer insertSublayer:gradient atIndex:0];
//
// 		UIView * bgEff = [bg valueForKey:@"_backgroundEffectView"];
// 		bgEff.alpha = 0;
// 	}
// 	else
// 	{ // removing it from the header
// 			if (self.barStyle > -1)
// 			{ // reverting back to original
// 				UIView * bg = [self.navigationController.navigationController.navigationBar valueForKey:@"_backgroundView"];
//
// 				if ([bg viewWithTag:6969])
// 				[[bg viewWithTag:6969] removeFromSuperview];
//
// 			  // [self.navigationController.navigationController.navigationBar _updateNavigationBarItemsForStyle:0];
// 				self.navigationController.navigationController.navigationBar.barStyle = 0; // woot need this :D
//
// 				UIView * bgEff = [bg valueForKey:@"_backgroundEffectView"];
// 				bgEff.alpha = 1;
//
// 				[UIApplication.sharedApplication setStatusBarStyle:self.barStyle];
// 			}
// 	}
// }

-(void)prepareBar {

	// if (!self.barStyle && self.barStyle != 0)
	// { // double check that a) it has a value and b) it's not thinking mode 0 = false
	// 	self.barStyle = UIApplication.sharedApplication.statusBarStyle;
	// 	[UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleLightContent];
	// }
	// self.navigationController.navigationController.navigationBar.tintColor = UIColor.whiteColor;
	// self.navigationController.navigationController.navigationBar.prefersLargeTitles = YES;

	// rightmost label
	UILabel *titleLabel = [[UILabel alloc] init];
	titleLabel.text = @"MASQ";
	titleLabel.textColor = UIColor.whiteColor;
	[titleLabel sizeToFit];
	UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
	self.navigationItem.rightBarButtonItem = right;

	//center icon title
	UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 32,32)];
	icon.image = [self imageFromBundle:@"Icon/Masq"];
	self.navigationItem.titleView = icon;

}

// - (id)tableView:(id)tableView viewForHeaderInSection:(NSInteger)section {
// 	return [super tableView:tableView viewForHeaderInSection:section];
// }
//
// - (CGFloat)tableView:(id)tableView heightForHeaderInSection:(NSInteger)section {
// 	return [super tableView:tableView heightForHeaderInSection:section];
// }
//
// -(UIImage *)bundleImageWithPath:(NSString *)n{
// 	return [UIImage imageNamed:n inBundle:[self bundle]];
// }
@end
