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

-(void)viewDidLoad {
	[super viewDidLoad];

		if (self.title)
		{
			UILabel *titleLabel = [[UILabel alloc] init];
			titleLabel.text = self.title;
			titleLabel.textColor = UIColor.whiteColor;
			[titleLabel sizeToFit];
			UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
			self.navigationItem.rightBarButtonItem = right;

			// hiding unwanted titles
			UIView * view = [[UIView alloc] init];
			self.navigationItem.titleView = view;

			// self.title = @"";
		}

		NSString * info = [self.specifier propertyForKey:@"versionInfo"];
		if (info)
		{
			UILabel * infoLabel = [[UILabel alloc] init];
			infoLabel.text = info;
			infoLabel.font = [infoLabel.font fontWithSize:10];
			infoLabel.textColor = UIColor.darkGrayColor;
			[infoLabel sizeToFit];
			infoLabel.center = CGPointMake(infoLabel.center.x, infoLabel.center.y + 4);

			if ([self valueForKey:@"_table"])
			{
				UITableView * table = [self valueForKey:@"_table"];
				[table addSubview:self.infoLabel = infoLabel];
			}
		}
}

-(void)viewWillAppear:(BOOL)arg1 {
	[super viewWillAppear:arg1];

	self.navigationController.navigationController.navigationBar.tintColor = UIColor.whiteColor;
	// self.navigationController.navigationController.navigationBar.barStyle = 0;

	[self wantsStyle:YES];


	if (self.infoLabel)
	self.infoLabel.center = CGPointMake(self.view.center.x, self.infoLabel.center.y);
	// {
	// }
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
	// [bg addSubview:myv];
	// [myv.layer insertSublayer:gradient atIndex:0];
	// UIView * bgEff = [bg valueForKey:@"_backgroundEffectView"];
	// bgEff.alpha = 0;

	// NSDictionary *settings = @{
  //   // UITextAttributeFont                 :  [UIFont fontWithName:@"YOURFONTNAME" size:20.0],
  //   UITextAttributeTextColor            :  [UIColor whiteColor],
  //   UITextAttributeTextShadowColor      :  [UIColor clearColor],
  //   UITextAttributeTextShadowOffset     :  [NSValue valueWithUIOffset:UIOffsetZero]
	// };
	//
	// self.navigationController.navigationController.navigationBar.titleTextAttributes = settings;


}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationController.navigationController.navigationBar.tintColor = nil;
	self.navigationController.navigationController.navigationBar.barTintColor = nil;
	// self.navigationController.navigationController.navigationBar.titleTextAttributes = nil;

	[self wantsStyle:NO];
	// UIView * bg = [self.navigationController.navigationController.navigationBar valueForKey:@"_backgroundView"];
	//
	// if ([bg viewWithTag:6969])
	// {
	// 	[[bg viewWithTag:6969] removeFromSuperview];
	// }
	//
  // // [self.navigationController.navigationController.navigationBar _updateNavigationBarItemsForStyle:0];
	// self.navigationController.navigationController.navigationBar.barStyle = 0; // woot need this :D
	// UIView * bgEff = [bg valueForKey:@"_backgroundEffectView"];
	// bgEff.alpha = 1;

	// [UIApplication.sharedApplication setStatusBarStyle:self.origStyle];

}

-(void)wantsStyle:(BOOL)arg1
{
	if (arg1)
	{ // adding it to the header
		// if (!self.origStyle)
		// {
		// 	self.origStyle = UIApplication.sharedApplication.statusBarStyle;
		// 	[UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleLightContent];
		// }
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
			// if (self.origStyle > -1)
			// { // reverting back to original
				UIView * bg = [self.navigationController.navigationController.navigationBar valueForKey:@"_backgroundView"];

				if ([bg viewWithTag:6969])
				[[bg viewWithTag:6969] removeFromSuperview];

			  // [self.navigationController.navigationController.navigationBar _updateNavigationBarItemsForStyle:0];
				self.navigationController.navigationController.navigationBar.barStyle = 0; // woot need this :D

				UIView * bgEff = [bg valueForKey:@"_backgroundEffectView"];
				bgEff.alpha = 1;

				// [UIApplication.sharedApplication setStatusBarStyle:self.origStyle];
			// }
	}
}

// - (UIStatusBarStyle)preferredStatusBarStyle
// {
//     return UIStatusBarStyleLightContent;
// }
@end
