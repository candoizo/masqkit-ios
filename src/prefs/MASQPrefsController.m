#import "MASQPrefsController.h"
#import "MASQLocalizer.h"
#import "MASQIntroView.h"
#import "MASQHeaderView.h"
#import "../MASQThemeManager.h"


@implementation MASQPrefsController
+(void)clearPrefs {
	[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:@"ca.ndoizo.masqkit"];
}

-(NSArray *)sortRules {
	return @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
}

- (NSArray *)specifiers {

	if (!_specifiers)
	{

		NSMutableArray * root = [[self loadSpecifiersFromPlistName:@"Root" target:self] mutableCopy];
		NSMutableArray * subprefs = [self buildForeignPrefs];

		if (subprefs.count > 0)
		{ // sort and add installed prefs
			[subprefs sortUsingDescriptors:[self sortRules]];
			[root addObjectsFromArray:subprefs];
		}
		else
		[self popMissingAlert];

		_specifiers = root;
		[NSClassFromString(@"MASQLocalizer") parseSpecifiers:_specifiers];
	}
	return _specifiers;
}

-(NSMutableArray *)buildForeignPrefs {
	NSString * subpath = [NSString stringWithFormat:@"%@/Prefs/", [self bundle].bundlePath];
	NSMutableArray * plugins = [NSMutableArray new];
	for (NSString * list in [NSFileManager.defaultManager contentsOfDirectoryAtPath:subpath error:nil])
	{
		if (![list hasSuffix:@"page.plist"])
		[plugins addObjectsFromArray:[self loadSpecifiersFromPlistName:[NSString stringWithFormat:@"Prefs/%@", [list stringByDeletingPathExtension]] target:self]];
	}
	return plugins;
}


-(void)popMissingAlert {
	UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"No Extensions!"
	message:@"MASQKit found no extensions installed on your device, and therefore has no options to offer you, yet: \n\n https://ndoizo.ca ← Add the repo to find some!"
	preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction* cancel = [NSClassFromString(@"UIAlertAction") actionWithTitle:@"Dismiss" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action)
	{
		[alert dismissViewControllerAnimated:YES completion:nil];
	}];


	UIAlertAction* repo = [NSClassFromString(@"UIAlertAction") actionWithTitle:@"Open in Cydia" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action)
	{
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"cydia://url/https://cydia.saurik.com/api/share#?source=https://ndoizo.ca"]];
	}];

	[alert addAction:repo];
	[alert addAction:cancel];

	[self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.prefs = [NSClassFromString(@"MASQThemeManager") prefs];
	[self prepareBar];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[self wantsStyle:YES];
	// if (!self.origStyle)
	// {
	// 	self.origStyle = UIApplication.sharedApplication.statusBarStyle;
	// 	[UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleLightContent];
	// }
	// self.navigationController.navigationController.navigationBar.tintColor = UIColor.whiteColor;
	//
	//
	// UIView * bg = [self.navigationController.navigationController.navigationBar valueForKey:@"_backgroundView"];
	//
	// UIView * myv = [[UIView alloc] initWithFrame:bg.bounds];
	// myv.tag = 6969;
	// myv.userInteractionEnabled = NO;
	//
	// CAGradientLayer *gradient = [NSClassFromString(@"CAGradientLayer") layer];
	// gradient.frame = bg.bounds;
	// gradient.colors = @[(id)[UIColor colorWithRed:0.29 green:0.64 blue:1.00 alpha:1.0].CGColor, (id)[UIColor colorWithRed:1.00 green:0.29 blue:0.52 alpha:1.0].CGColor];
	// gradient.startPoint = CGPointMake(0.0,0.5);
	// gradient.endPoint = CGPointMake(1.0,1.0);
	//
	// [bg addSubview:myv];
	// [myv.layer insertSublayer:gradient atIndex:0];
	//
	// UIView * bgEff = [bg valueForKey:@"_backgroundEffectView"];
	// bgEff.alpha = 0;


	[self reloadSpecifiers];
}

-(void)wantsStyle:(BOOL)arg1
{
	if (arg1)
	{ // adding it to the header
		if (!self.origStyle)
		{
			self.origStyle = UIApplication.sharedApplication.statusBarStyle;
			[UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleLightContent];
		}
		self.navigationController.navigationController.navigationBar.tintColor = UIColor.whiteColor;


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
	else
	{ // removing it from the header
			if (self.origStyle > -1)
			{ // reverting back to original
				UIView * bg = [self.navigationController.navigationController.navigationBar valueForKey:@"_backgroundView"];

				if ([bg viewWithTag:6969])
				[[bg viewWithTag:6969] removeFromSuperview];

			  // [self.navigationController.navigationController.navigationBar _updateNavigationBarItemsForStyle:0];
				self.navigationController.navigationController.navigationBar.barStyle = 0; // woot need this :D

				UIView * bgEff = [bg valueForKey:@"_backgroundEffectView"];
				bgEff.alpha = 1;

				[UIApplication.sharedApplication setStatusBarStyle:self.origStyle];
			}
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationController.navigationController.navigationBar.titleTextAttributes = nil;
	self.navigationController.navigationController.navigationBar.tintColor = nil;
	self.navigationController.navigationController.navigationBar.barTintColor = nil;

	[self wantsStyle:NO];
	// if (self.origStyle > -1)
	// { // reverting back to original
	// 	UIView * bg = [self.navigationController.navigationController.navigationBar valueForKey:@"_backgroundView"];
	//
	// 	if ([bg viewWithTag:6969])
	// 	[[bg viewWithTag:6969] removeFromSuperview];
	//
	//   [self.navigationController.navigationController.navigationBar _updateNavigationBarItemsForStyle:0];
	// 	self.navigationController.navigationController.navigationBar.barStyle = 0; // woot need this :D
	//
	// 	UIView * bgEff = [bg valueForKey:@"_backgroundEffectView"];
	// 	bgEff.alpha = 1;
	//
	// 	[UIApplication.sharedApplication setStatusBarStyle:self.origStyle];
	// }
}

- (id)tableView:(id)tableView viewForHeaderInSection:(NSInteger)section {
	return [super tableView:tableView viewForHeaderInSection:section];
}

- (CGFloat)tableView:(id)tableView heightForHeaderInSection:(NSInteger)section {
	return [super tableView:tableView heightForHeaderInSection:section];
}

-(UIImage *)imageFromPrefsWithName:(NSString *)n{
	return [UIImage imageNamed:n inBundle:[self bundle]];
}

-(void)prepareBar {

	if (!self.origStyle)
	{
		self.origStyle = UIApplication.sharedApplication.statusBarStyle;
		[UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleLightContent];
	}
	self.navigationController.navigationController.navigationBar.tintColor = UIColor.whiteColor;
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
	icon.image = [self imageFromPrefsWithName:@"Icon/Masq"];
	self.navigationItem.titleView = icon;

}

@end
