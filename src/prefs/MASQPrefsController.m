#import "MASQPrefsController.h"
#import "MASQLocalizer.h"
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

-(NSMutableArray *)buildForeignPrefs {

	NSString * path = [NSString stringWithFormat:@"%@/Prefs/", self.bundle.bundlePath];
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
@end
