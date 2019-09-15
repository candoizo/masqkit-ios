#import "MASQThemePicker.h"
#import "../MASQThemeManager.h"
#import "../UIColor+MASQColorUtil.h"
#import "MediaRemote/MediaRemote.h"

@implementation MASQThemePicker

- (void)viewDidLoad {
	[super viewDidLoad];
	self.prefs = [NSClassFromString(@"MASQThemeManager") prefs];
	// self.title = @"Themes";

	UILabel *titleLabel = [[UILabel alloc] init];
	titleLabel.text = @"Themes";
	titleLabel.textColor = UIColor.whiteColor;
	[titleLabel sizeToFit];
	UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
	self.navigationItem.rightBarButtonItem = right;
	UIView * view = [[UIView alloc] init]; // hiding title permanently
	self.navigationItem.titleView = view;


	self.selectedTheme = [self.prefs valueForKey:[self themeKey]];
  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  // self.tableView.rowHeight = 65.0f;
	self.tableView.tintColor = [self themeTint];
	[self.view addSubview:self.tableView];

	NSNotificationCenter * def = NSNotificationCenter.defaultCenter;
	[def addObserver:self selector:@selector(updateArtworkUgly)  name:@"_MRMediaRemotePlayerNowPlayingInfoDidChangeNotification" object:nil];
}

- (void)updateThemeList {
	 // create the theme list, starting with the default theme
	// NSMutableArray *themes = [@[@{@"bundle":@"Disabled@100", @"name":@"Disabled", @"scale":@"100"}] mutableCopy];
	NSMutableArray * themes = [NSMutableArray new];
	NSString * themePath = [self themePath];
	NSDictionary * defaultTheme = nil;
	// HBLogDebug(@"Theme path: %@", [self themePath]);
	// for all the installed bundles in /Application Support/MASQ/Themes/x.bundle
	for (NSString * bundles in [NSFileManager.defaultManager contentsOfDirectoryAtPath:themePath error:nil])
	{
		if ([bundles hasSuffix:@".bundle"])
		{
		// Path to theme bundle
			NSString * tbPath = [NSString stringWithFormat:@"%@/%@", themePath, bundles];
			// HBLogDebug(@"tbPath: %@", tbPath);
			// for all themes or theme installed in the bundle
			for (NSString * themeid in [NSFileManager.defaultManager contentsOfDirectoryAtPath:tbPath error:nil])
			{
				// if (![themes containsObject:@"@"]) //coult implement plist dict

				//old simple way by path
				NSArray * theme = [themeid componentsSeparatedByString:@"@"];
				NSString * bthemeId = [NSString stringWithFormat:@"%@/%@", bundles, themeid];
				NSString * name = theme.firstObject;
				NSString * scale = theme.lastObject;

				NSString * credPath = [NSString stringWithFormat:@"%@/%@/Credit.txt",
				tbPath, themeid];
				if ([NSFileManager.defaultManager fileExistsAtPath:credPath])
				{
					NSString * credit = [NSString stringWithContentsOfFile:credPath encoding:NSUTF8StringEncoding error:nil];
					[themes addObject:@{ @"bundle":bthemeId, @"name":name, @"scale":scale, @"author":credit ?: @""}];
				}
				else {
					// no credit exists
					if ([bthemeId isEqualToString:@"Default.bundle/Default@100"])
					defaultTheme = @{ @"bundle":bthemeId, @"name":name, @"scale":scale, @"author":@""};

					else //if not the default add normally
					[themes addObject:@{ @"bundle":bthemeId, @"name":name, @"scale":scale, @"author":@""}];
				}
			}
		}
	}

	if (themes.count > 0)
	{
		NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
		[themes sortUsingDescriptors:[NSArray arrayWithObject:sort]];
		if (defaultTheme)
		[themes insertObject:defaultTheme atIndex:0];
		// [root addObjectsFromArray:subprefs];
	}
	self.themes = themes;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    NSString *sectionName;
    switch (section) {
        case 0:
					sectionName = @"Preview";
        break;
        default:
          sectionName = @"";
        break;
    }
    return sectionName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0)
	return 140;
	else
	return 55;
}


-(void)updateArtworkUgly {
	if (self.lightArtwork && self.darkArtwork)
	MRMediaRemoteGetNowPlayingInfo(
		dispatch_get_main_queue(), ^(CFDictionaryRef information) {
			NSDictionary *dict = (__bridge NSDictionary *)(information);

			UIImage * img = [UIImage imageWithData:dict[@"kMRMediaRemoteNowPlayingInfoArtworkData"]];
			if (!img && !self.lightArtwork.activeAudio)
			img = [self imageFromPrefsWithName:@"Icon/Placeholder"];

			self.lightArtwork.artworkImageView.image = img;
			self.darkArtwork.artworkImageView.image = img;

			if (self.stylePreview && img)
			self.stylePreview.image =  img;
		}
	);
}

-(UIImage *)imageFromPrefsWithName:(NSString *)n{
	return [UIImage imageNamed:n inBundle:[NSBundle bundleWithPath:@"/Library/PreferenceBundles/MASQSettings.bundle"]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	if (indexPath.section == 0)
	{ // theme previewer
	  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PreviewCell"];
		cell.userInteractionEnabled = NO;
		// cell.rowHeight = 120;
	  cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = nil;

		// a fake artwork view for positioning
		float rowHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath];
		UIImageView * contain = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,120,120)];
		contain.center = CGPointMake(tableView.center.x*1.5, rowHeight*0.5);
		contain.hidden = YES;
		[cell addSubview:contain];

		MASQArtworkView * light = [[NSClassFromString(@"MASQArtworkView") alloc] initWithThemeKey:[self themeKey] frameHost:contain imageHost:contain];
		self.lightArtwork = light;
		[cell addSubview:light];

		UIImageView * containd = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,120,120)];
		containd.center = CGPointMake(tableView.center.x/2, rowHeight*0.5);
		containd.hidden = YES;
		[cell addSubview:containd];

		MASQArtworkView * dark = [[NSClassFromString(@"MASQArtworkView") alloc] initWithThemeKey:[self themeKey] frameHost:containd imageHost:contain];
		self.darkArtwork = dark;
		[cell addSubview:dark];

		[self updateArtworkUgly];

		UIImageView * lay = [[UIImageView alloc] initWithFrame:cell.frame];
		self.stylePreview = lay;
		lay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

		UIVisualEffectView * v = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
		v.frame = CGRectMake(0,0,self.view.bounds.size.width/2, lay.bounds.size.height);
		v.contentMode = UIViewContentModeScaleAspectFill;
		v.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[lay addSubview:v];

		UIVisualEffectView * d = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
		d.frame = CGRectMake(self.view.bounds.size.width/2,0,self.view.bounds.size.width/2, lay.bounds.size.height);
		d.contentMode = UIViewContentModeScaleAspectFill;
		d.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[lay addSubview:d];

		[cell insertSubview:lay atIndex:0];

		return cell;
	}

  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ThemeCell"];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;

	NSDictionary *themeInfo = self.themes[indexPath.row];
	cell.textLabel.text = themeInfo[@"name"];

	if (themeInfo[@"author"]) {
		cell.detailTextLabel.text = themeInfo[@"author"];
		cell.detailTextLabel.textColor = UIColor.darkGrayColor;
	}

  if (!self.checkedIndexPath && [themeInfo[@"bundle"] isEqualToString:self.selectedTheme]) self.checkedIndexPath = indexPath;
	cell.accessoryType = (indexPath == self.checkedIndexPath) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if (!(cell.accessoryType == UITableViewCellAccessoryCheckmark)) {

		UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.checkedIndexPath];
		oldCell.accessoryType = UITableViewCellAccessoryNone;
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		self.checkedIndexPath = indexPath;

		// save selection to prefs
		self.selectedTheme = self.themes[indexPath.row][@"bundle"];

		// HBLogDebug(@"self.selectedTheme %@", self.selectedTheme);
		[self.prefs setValue:self.selectedTheme forKey:[self themeKey]];

		Class _cfx = NSClassFromString(@"_CFXPreferences");
		// basically this if statement actually fucks us up
		// the like one milisecond delay makes it not update intime for 3rd party apps
		// if (/[_cfx respondsToSelector:@selector(flushCachesForAppIdentifier:user:)])
		// but the version doesnt cause the same problem :D
		// if (UIDevice.currentDevice.systemVersion.doubleValue > 11)
		// { //basically this check was making it not update fast enough on ios 11.0.2 :o
		if (_cfx)
		{
			_CFXPreferences *prefs = [_cfx copyDefaultPreferences];
			[prefs flushCachesForAppIdentifier:(__bridge CFStringRef)@"ca.ndoizo.masqkit" user:(__bridge CFStringRef)@"/User"];
		}
		// }

		if (self.lightArtwork)
		{
			[self.lightArtwork updateTheme];
			// [self.lightArtwork __grrrr];
		}
		if (self.darkArtwork)
		{
			[self.darkArtwork updateTheme];
			// [self.darkArtwork __grrrr]; // needs to go somewhere else, probably in the MASQArtworkView playbackState method
		}
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[self wantsStyle:YES];

	[self updateThemeList];
	if (self.themes.count <= 1)
	[self popMissingAlert];
}

- (void)viewWillDisappear:(BOOL)animated {
	self.navigationController.navigationController.navigationBar.tintColor = nil;
	[super viewWillDisappear:animated];

	[self wantsStyle:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// one for the preview, one for the theme rows
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	if (section == 0)
	return 1;
	else if (section == 1)
	return self.themes.count;
	else
	return 0;
}

-(NSString *)themeKey {
  return [self.specifier propertyForKey:@"themeKey"];
}

-(NSString *)themePath {
  return @"/Library/Application Support/MASQ/Themes";
}

-(UIColor *)themeTint {
	if ([self.specifier propertyForKey:@"tint"])
	return [UIColor _masq_hexToRGB:[self.specifier propertyForKey:@"tint"]];
	else return [UIColor colorWithRed:0.87 green:0.25 blue:0.40 alpha:1];
}

-(void)popMissingAlert {
			UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"No Themes!"
			message:@"MASQKit found no themes installed on your device, and therefore has no choices to offer you, yet: \n\n https://ndoizo.ca ← Visit the repo to find some!"
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

-(void)wantsStyle:(BOOL)arg1
{
	if (arg1)
	{ // adding it to the header
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

		UIView * bg = [self.navigationController.navigationController.navigationBar valueForKey:@"_backgroundView"];

		if ([bg viewWithTag:6969])
		[[bg viewWithTag:6969] removeFromSuperview];

		self.navigationController.navigationController.navigationBar.barStyle = 0; // woot need this :D

		UIView * bgEff = [bg valueForKey:@"_backgroundEffectView"];
		bgEff.alpha = 1;
	}
}
@end
