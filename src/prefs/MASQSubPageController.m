#import "Preferences/PSSpecifier.h"
#import "MASQLocalizer.h"
#import "MASQSubPageController.h"

@implementation MASQSubPageController
- (NSArray *)specifiers {

	if (!_specifiers)	{
		_specifiers = [self loadSpecifiersFromPlistName:[NSString stringWithFormat:@"Prefs/%@", [self.specifier propertyForKey:@"specs"]] target:self];

		[NSClassFromString(@"MASQLocalizer") parseSpecifiers:_specifiers];
	}
	return _specifiers;
}

-(void)viewDidLoad {
	[super viewDidLoad];

	if (self.title)
	{ // replace title
		UILabel *titleLabel = [[UILabel alloc] init];
		titleLabel.text = self.title;
		titleLabel.textColor = UIColor.whiteColor;
		[titleLabel sizeToFit];

		UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
		self.navigationItem.rightBarButtonItem = right;

		// hiding unwanted titles
		UIView * view = [[UIView alloc] init];
		self.navigationItem.titleView = view;
	}
}

-(void)viewWillAppear:(BOOL)arg1 {
	[super viewWillAppear:arg1];

	if (!self.infoLabel)
	{
		NSString * info = [self.specifier propertyForKey:@"versionInfo"];
		if (info)
		{
			UILabel * infoLabel = [[UILabel alloc] init];
			infoLabel.text = info;
			infoLabel.font = [infoLabel.font fontWithSize:10];
			infoLabel.textColor = UIColor.darkGrayColor;
			[infoLabel sizeToFit];
			infoLabel.center = CGPointMake(infoLabel.center.x, infoLabel.center.y - 20);

			if ([self valueForKey:@"_table"])
			{
				UITableView * table = [self valueForKey:@"_table"];
				[table addSubview:self.infoLabel = infoLabel];
			}
		}
	}
	else
	self.infoLabel.center = CGPointMake(self.view.center.x, self.infoLabel.center.y);
}
@end
