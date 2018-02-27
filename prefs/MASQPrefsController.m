#import "PrefUtils.h"
#import "MASQPrefsController.h"
#import "MASQLocalizer.h"
#import "MASQIntroView.h"
#import "MASQHeaderView.h"
#import "MASQSocialExtendedController.h"
#import "../src/MASQThemeManager.h"

@implementation MASQPrefsController
+(void)clearPrefs { [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:@"ca.ndoizo.masq"]; }

- (NSArray *)specifiers {
	if (!_specifiers)	{
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
		[NSClassFromString(@"MASQLocalizer") parseSpecifiers:_specifiers];
	}
	return _specifiers;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.prefs = [NSClassFromString(@"MASQThemeManager") sharedPrefs];
	self.navigationItem.rightBarButtonItem = [self loveButton];
}

- (void)viewWillAppear:(BOOL)animated {
	//obv fix before release
	if ([self.prefs boolForKey:@"firstTime"]) [self.prefs setBool:NO forKey:@"firstTime"];
	else [self.view addSubview:[[MASQIntroView alloc] init]];

	[super viewWillAppear:animated];
	[self reloadSpecifiers];
	self.navigationController.navigationController.navigationBar.barTintColor = kCustomTint;
	self.navigationController.navigationController.navigationBar.tintColor = UIColor.whiteColor;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationController.navigationController.navigationBar.tintColor = nil;
	self.navigationController.navigationController.navigationBar.barTintColor = nil;
}

- (id)tableView:(id)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		CGFloat sectionH = [self tableView:tableView heightForHeaderInSection:section];
		return [[MASQHeaderView alloc]
		initWithFrame:CGRectMake(0,0,self.view.bounds.size.width, sectionH)
		tweakTitle:@"MASQ²"
		iconImage:[self imageFromPrefsWithName:@"Icon"]];
	}
	else return [super tableView:tableView viewForHeaderInSection:section];
}

- (CGFloat)tableView:(id)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) return 120;
	else return [super tableView:tableView heightForHeaderInSection:section];
}

-(UIBarButtonItem *)loveButton {
	return [[UIBarButtonItem alloc] initWithTitle:[self.prefs boolForKey:@"loveTweak"] ?  @"♥":@"♡" style:UIBarButtonItemStylePlain target:self action:@selector(showLove)];
}

-(void)showLove {
	MASQSocialExtendedController * contr = [MASQSocialExtendedController composeViewControllerForServiceType:SLServiceTypeTwitter];

	[contr setCompletionHandler:^(SLComposeViewControllerResult result) {
		if (result == SLComposeViewControllerResultDone) {
				if (![self.prefs boolForKey:@"loveTweak"]) {
					 self.navigationItem.rightBarButtonItem.title = @"♥";
					 [self.prefs setBool:YES forKey:@"loveTweak"];
				}
			}
		}];

		[self presentViewController:contr animated:YES completion:nil];
}

-(UIImage *)imageFromPrefsWithName:(NSString *)n {
	return [UIImage imageNamed:n inBundle:[NSBundle bundleWithPath:@"/Library/PreferenceBundles/MASQPrefs.bundle"]];
}
@end
