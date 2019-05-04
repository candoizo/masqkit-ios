#import "MASQPrefsController.h"
#import "MASQLocalizer.h"
#import "MASQIntroView.h"
#import "MASQHeaderView.h"
// #import "MASQSocialExtendedController.h"
#import "../MASQThemeManager.h"

@interface UIImage (livate)
+ (UIImage *)imageNamed:(id)img inBundle:(id)bndl;
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(int)scale;
@end

@implementation MASQPrefsController
+(void)clearPrefs { [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:@"ca.ndoizo.masqkit"]; }

- (NSArray *)specifiers {
	if (!_specifiers)	{
		NSMutableArray * root = [[self loadSpecifiersFromPlistName:@"Root" target:self] mutableCopy];
		NSMutableArray * subprefs = [self buildForeignPrefs];
		!subprefs.count ? [self popMissingAlert] : [root addObjectsFromArray:subprefs];
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
	// self.navigationItem.rightBarButtonItem = [self loveButton];
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
	[self reloadSpecifiers];
	self.navigationController.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.87 green:0.25 blue:0.40 alpha:1];
	self.navigationController.navigationController.navigationBar.tintColor = UIColor.whiteColor;
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

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationController.navigationController.navigationBar.tintColor = nil;
	self.navigationController.navigationController.navigationBar.barTintColor = nil;
}

- (id)tableView:(id)tableView viewForHeaderInSection:(NSInteger)section
{
	if (section == 0) {
		CGFloat sectionH = [self tableView:tableView heightForHeaderInSection:section];
		return [[MASQHeaderView alloc]
		initWithFrame:CGRectMake(0,0,self.view.bounds.size.width, sectionH)
		tweakTitle:@"MASQ"
		iconImage:[self imageFromPrefsWithName:@"Icon/Icon"]];
	}
	else return [super tableView:tableView viewForHeaderInSection:section];
}

- (CGFloat)tableView:(id)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) return 120;
	else return [super tableView:tableView heightForHeaderInSection:section];
}
-(UIImage *)imageFromPrefsWithName:(NSString *)n
{
	return [UIImage imageNamed:n inBundle:[self bundle]];
}
@end
