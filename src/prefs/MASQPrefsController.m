#import "MASQPrefsController.h"
#import "MASQLocalizer.h"
#import "MASQIntroView.h"
#import "MASQHeaderView.h"
// #import "MASQSocialExtendedController.h"
#import "../MASQThemeManager.h"

@interface UIImage (Private)
+ (UIImage *)imageNamed:(id)img inBundle:(id)bndl;
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(int)scale;
@end

@implementation MASQPrefsController
+(void)clearPrefs { [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:@"ca.ndoizo.masqkit"]; }

- (NSArray *)specifiers {
	if (!_specifiers)	{
		NSMutableArray * root = [[self loadSpecifiersFromPlistName:@"Root" target:self] mutableCopy];

		NSMutableArray * subprefs = [self buildForeignPrefs];
		if (subprefs.count > 0)
		{
			NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
			[subprefs sortUsingDescriptors:[NSArray arrayWithObject:sort]];

			[root addObjectsFromArray:subprefs];
		}
		else
		[self popMissingAlert];

		// !subprefs.count ? [self popMissingAlert] : [root addObjectsFromArray:subprefs];
		_specifiers = root;
		[NSClassFromString(@"MASQLocalizer") parseSpecifiers:_specifiers];
	}
	return _specifiers;
}

-(NSMutableArray *)buildForeignPrefs {
	NSString * subpath = [NSString stringWithFormat:@"%@/Prefs/", [self bundle].bundlePath];
	NSMutableArray * plugins = [NSMutableArray new];
	for (NSString * list in [NSFileManager.defaultManager contentsOfDirectoryAtPath:subpath error:nil]) {
		if (![list hasSuffix:@"page.plist"]) [plugins addObjectsFromArray:[self loadSpecifiersFromPlistName:[NSString stringWithFormat:@"Prefs/%@", [list stringByDeletingPathExtension]] target:self]];
	}
	return plugins;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.prefs = [NSClassFromString(@"MASQThemeManager") prefs];

	[self prepareBar];
}


-(void)popMissingAlert {
			UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"No Extensions!"
			message:@"MASQKit found no extensions installed on your device, and therefore has no options to offer you, yet: \n\n https://ndoizo.ca ← Add the repo to find some!"
			preferredStyle:UIAlertControllerStyleAlert];

			UIAlertAction* cancel = [NSClassFromString(@"UIAlertAction") actionWithTitle:@"Dismiss" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action){
																[alert dismissViewControllerAnimated:YES completion:nil];
															}];

			UIAlertAction* repo = [NSClassFromString(@"UIAlertAction") actionWithTitle:@"Open in Cydia" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
															[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"cydia://url/https://cydia.saurik.com/api/share#?source=https://ndoizo.ca"]];
															}];

			[alert addAction:repo];
			[alert addAction:cancel];
			[self presentViewController:alert animated:YES completion:nil];
}


- (void)viewWillAppear:(BOOL)animated {
	// if ([self.prefs boolForKey:@"firstTime"]) [self.prefs setBool:NO forKey:@"firstTime"]; 	//obv fix before release
	// else [self.view addSubview:[[MASQIntroView alloc] init]];

	// //if they havent seen this their first time opening
	// if (![self.prefs boolForKey:@"firstTime"])
	// {
	// 	[self.view addSubview:[[MASQIntroView alloc] init]];
	// }

	[super viewWillAppear:animated];



	if (!self.origStyle)
	{
		self.origStyle = UIApplication.sharedApplication.statusBarStyle;
		[UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleLightContent];
	}
	self.navigationController.navigationController.navigationBar.tintColor = UIColor.whiteColor;

	UIView * con = nil;
	for (UIView * sv in self.navigationController.navigationController.navigationBar.subviews)
	{
		if ([sv isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")])
		con = sv;
	}
	//
	if (con)
	{
			UIView * bg = [self.navigationController.navigationController.navigationBar valueForKey:@"_backgroundView"];

			UIView * myv = [[UIView alloc] initWithFrame:bg.bounds];
			myv.tag = 6969;
			myv.userInteractionEnabled = NO;
			// [con insertSubview:myv atIndex:0];

				CAGradientLayer *gradient = [NSClassFromString(@"CAGradientLayer") layer];
				gradient.frame = bg.bounds;
				gradient.colors = @[(id)[UIColor colorWithRed:0.29 green:0.64 blue:1.00 alpha:1.0].CGColor, (id)[UIColor colorWithRed:1.00 green:0.29 blue:0.52 alpha:1.0].CGColor];
				gradient.startPoint = CGPointMake(0.0,0.5);
			  gradient.endPoint = CGPointMake(1.0,1.0);
				// [titleLabel addSublayer:gradient];
				[bg addSubview:myv];
				[myv.layer insertSublayer:gradient atIndex:0];
				// [self.view addSubview:con];
	}

	UIView * bg = [self.navigationController.navigationController.navigationBar valueForKey:@"_backgroundView"];
	UIView * bgEff = [bg valueForKey:@"_backgroundEffectView"];
	bgEff.alpha = 0;


	[self reloadSpecifiers];
	// [self prepareBar];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationController.navigationController.navigationBar.tintColor = nil;
	self.navigationController.navigationController.navigationBar.barTintColor = nil;

	if (self.origStyle > -1)
	{ // reverting back to original
		UIView * bg = [self.navigationController.navigationController.navigationBar valueForKey:@"_backgroundView"];

		if ([bg viewWithTag:6969])
		{
			[[bg viewWithTag:6969] removeFromSuperview];
		}

  [self.navigationController.navigationController.navigationBar _updateNavigationBarItemsForStyle:0];
	self.navigationController.navigationController.navigationBar.barStyle = 0; // woot need this :D
		UIView * bgEff = [bg valueForKey:@"_backgroundEffectView"];
		// if (bgEff.layer.sublayers)
		// if (self.origBar)
		// for (UIView * sub in bgEff.subviews)
		// {
		// 	// need to hide most except this one because it fucks up when its hidden
		// 	if ([sub isMemberOfClass:NSClassFromString(@"_UIVisualEffectSubview")])
		// 	{
		// 		// sub.backgroundColor = self.origBar;
		// 		break;
		// 	}
		// }
		// bgEff.alpha = 1;

		// for (UIView * sub in bgEff.subviews)
		// {
		// 	sub.hidden = NO;
		// }
		// UIView * bgEff = [bg valueForKey:@"_backgroundEffectView"];
		bgEff.alpha = 1;




		// if (bg.layer.sublayers[0])
		// if ([bg.layer.sublayers[0] isKindOfClass:NSClassFromString(@"CAGradientLayer")])
		// [bg.layer.sublayers[0] removeFromSuperlayer];
		//
		[UIApplication.sharedApplication setStatusBarStyle:self.origStyle];
	}
}

- (id)tableView:(id)tableView viewForHeaderInSection:(NSInteger)section
{
	// if (section == 0) {
	// 	CGFloat sectionH = [self tableView:tableView heightForHeaderInSection:section];
	// 	return [[MASQHeaderView alloc]
	// 	initWithFrame:CGRectMake(0,0,self.view.bounds.size.width, sectionH)
	// 	tweakTitle:@"MASQ"
	// 	iconImage:[self imageFromPrefsWithName:@"Icon/Icon"]];
	// }
	// else
	return [super tableView:tableView viewForHeaderInSection:section];
}

- (CGFloat)tableView:(id)tableView heightForHeaderInSection:(NSInteger)section {
	// if (section == 0) return 120;
	// else
	return [super tableView:tableView heightForHeaderInSection:section];
}

-(UIImage *)imageFromPrefsWithName:(NSString *)n
{
	return [UIImage imageNamed:n inBundle:[self bundle]];
}


-(void)prepareBar {

	// set colors
	// self.navigationController.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.87 green:0.25 blue:0.40 alpha:1];
	if (!self.origStyle)
	{
		self.origStyle = UIApplication.sharedApplication.statusBarStyle;
		[UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleLightContent];
	}
	self.navigationController.navigationController.navigationBar.tintColor = UIColor.whiteColor;

	// UIView * con = nil;
	// for (UIView * sv in self.navigationController.navigationController.navigationBar.subviews)
	// {
	// 	if ([sv isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")])
	// 	con = sv;
	// }
	// //
	// if (con)
	// {
	// 		UIView * bg = [self.navigationController.navigationController.navigationBar valueForKey:@"_backgroundView"];
	//
	// 		UIView * myv = [[UIView alloc] initWithFrame:bg.bounds];
	// 		myv.tag = 6969;
	// 		myv.userInteractionEnabled = NO;
	// 		// [con insertSubview:myv atIndex:0];
	//
	// 			CAGradientLayer *gradient = [NSClassFromString(@"CAGradientLayer") layer];
	// 			gradient.frame = bg.bounds;
	// 			gradient.colors = @[(id)[UIColor colorWithRed:0.29 green:0.64 blue:1.00 alpha:1.0].CGColor, (id)[UIColor colorWithRed:1.00 green:0.29 blue:0.52 alpha:1.0].CGColor];
	// 			gradient.startPoint = CGPointMake(0.0,0.5);
	// 		  gradient.endPoint = CGPointMake(1.0,1.0);
	// 			// [titleLabel addSublayer:gradient];
	// 			[bg addSubview:myv];
	// 			[myv.layer insertSublayer:gradient atIndex:0];
	// 			// [self.view addSubview:con];
	// }
	//
	// UIView * bg = [self.navigationController.navigationController.navigationBar valueForKey:@"_backgroundView"];
	// // UIView * sta = [self.navigationController.navigationController.navigationBar valueForKey:@"_stack"];
	// // //
	// //
	// // //
	// // UIView * content = nil;
	// UIView * bgEff = [bg valueForKey:@"_backgroundEffectView"];
	// // for (UIView * sub in bgEff.subviews)
	// // {
	// // // 	// need to hide most except this one because it fucks up when its hidden
	// // 	if ([sub isMemberOfClass:NSClassFromString(@"_UIVisualEffectSubview")])
	// // 	{
	// // 		content = sub;
	// // 		break;
	// // 	}
	// // }
	// // if (content) {
	// bgEff.alpha = 0;
	// UIView * myv = [[UIView alloc] initWithFrame:bg.bounds];
	// myv.tag = 6969;
	// [content addSubview:myv];
	// CAGradientLayer *gradient = [NSClassFromString(@"CAGradientLayer") layer];
	// gradient.frame = bg.bounds;
	// gradient.colors = @[(id)[UIColor colorWithRed:0.29 green:0.64 blue:1.00 alpha:1.0].CGColor, (id)[UIColor colorWithRed:1.00 green:0.29 blue:0.52 alpha:1.0].CGColor];
	// gradient.startPoint = CGPointMake(0.0,0.5);
  // gradient.endPoint = CGPointMake(1.0,1.0);
	// self.origBar = gradient;
	// // [titleLabel addSublayer:gradient];
	// [myv.layer insertSublayer:gradient atIndex:0];
	//
	// }

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
// jk i totally dont need this
// // need this to avoid some weird bug where the navbar turns grey? jk idk
// - (UIStatusBarStyle)preferredStatusBarStyle
// {
//     return UIStatusBarStyleLightContent;
// }
@end
