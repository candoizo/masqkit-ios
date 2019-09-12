#import "MASQThemePicker.h"
#import "../MASQThemeManager.h"
#import "MediaRemote/MediaRemote.h"

@interface _CFXPreferences : NSObject
+ (_CFXPreferences *)copyDefaultPreferences;
- (void)flushCachesForAppIdentifier:(CFStringRef)arg1 user:(CFStringRef)arg2;
@end

@implementation MASQThemePicker
- (void)viewDidLoad {
	[super viewDidLoad];
	self.prefs = [NSClassFromString(@"MASQThemeManager") prefs];
	self.title = @"Themes";
	self.selectedTheme = [self.prefs valueForKey:[self themeKey]];
  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  // self.tableView.rowHeight = 65.0f;
	self.tableView.tintColor = [self themeTint];
	[self.view addSubview:self.tableView];
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

	//
  // for (NSString * themeid in [NSFileManager.defaultManager contentsOfDirectoryAtPath:[self themePath] error:nil]) {
  //     NSArray * theme = [themeid componentsSeparatedByString:@"@"];
  //   	NSString *named = theme.firstObject;
  //   	NSString *scaling = theme.lastObject;
	// 		NSString *credit = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/Credit.txt", [self themePath], themeid] encoding:NSUTF8StringEncoding error:nil];
	// 		[themes addObject:@{ @"bundle":themeid, @"name":named, @"scale":scaling, @"author":credit ?: @""}];
  // }

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
          // sectionName = NSLocalizedString(@"mySectionName", @"mySectionName");
        break;
        case 1:
          // sectionName = NSLocalizedString(@"myOtherSectionName", @"myOtherSectionName");
        break;
        // ...
        default:
          sectionName = @"";
        break;
    }
    return sectionName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0)
	return 135;
	else
	return 62.5f;
}

-(id)fetchArtwork {
	// need to investigate how to support spotify artwork
	// cont = [NSClassFromString(@"MPMusicPlayerController") applicationMusicPlayer] ?: [NSClassFromString(@"MPMusicPlayerController") systemMusicPlayer];
	MPMusicPlayerController * cont = [NSClassFromString(@"MPMusicPlayerController") systemMusicPlayer];
	UIImage * art = [cont.nowPlayingItem.artwork imageWithSize:CGSizeMake(120,120)];

	return art;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	if (indexPath.section == 0)
	{ // theme previewer
	  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ThemeCell"];
		cell.userInteractionEnabled = NO;
		// cell.rowHeight = 120;
	  cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = nil;

		// hide separator hack
		// cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
		// tableView.separatorColor = [UIColor clearColor];
		// tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		// int style = 2;
  	// UIBlurEffect * eff; switch (style) {
    // 	case 1: eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]; break;
    // 	case 2: eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]; break;
    // 	case 3: eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]; break;
  	// }
		//
		// // blur to aid contrast
		// UIVisualEffectView * v = [[UIVisualEffectView alloc] initWithEffect:eff];
		// v.frame = CGRectMake(0,0,cell.bounds.size.width, cell.bounds.size.height);
		// v.contentMode = UIViewContentModeScaleAspectFill;
		// v.backgroundColor = UIColor.lightGrayColor;
		// v.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		// [cell addSubview:v];

		// a fake artwork view for positioning
		UIImageView * contain = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,120,120)];
		float rowHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath];
		contain.center = CGPointMake(tableView.center.x, rowHeight*0.5);
		contain.image = [self fetchArtwork];
		contain.hidden = YES;
		[cell addSubview:contain];

		MASQArtworkView * view = [[NSClassFromString(@"MASQArtworkView") alloc] initWithThemeKey:[self themeKey] frameHost:contain imageHost:contain];
		self.artwork = view;
		[cell addSubview:view];

		return cell;
	}

  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ThemeCell"];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;

	NSDictionary *themeInfo = self.themes[indexPath.row];
	cell.textLabel.text = themeInfo[@"name"];


	// cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
	//
	// UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.height/1.5, cell.bounds.size.height/1.5)];
	//
	// icon.contentMode = UIViewContentModeScaleAspectFit;
	// [cell addSubview:icon];
	//
	// NSString *path = [themeInfo[@"name"] isEqualToString:@"Default"] ?
	// @"/Library/PreferenceBundles/MASQPrefs.bundle/Default.png"
	// :
	// [NSString stringWithFormat:@"%@/%@/Icon.png", [self themePath], themeInfo[@"bundle"]];
	// icon.image = [UIImage imageWithContentsOfFile:path];
	// cell.imageView.image = icon.image;
	// cell.imageView.alpha = 0;
	// cell.imageView.bounds = CGRectMake(15, 5, 20, 20);
	// icon.center = cell.imageView.center;

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

		if (self.artwork)
		[self.artwork updateTheme];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	 [super viewWillAppear:animated];
	 self.navigationController.navigationController.navigationBar.tintColor = [self themeTint];
	 [self updateThemeList];

	 if (self.themes.count <= 1)
	 [self popMissingAlert];
}

- (void)viewWillDisappear:(BOOL)animated {
	self.navigationController.navigationController.navigationBar.tintColor = nil;
	[super viewWillDisappear:animated];
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
	return [MASQThemePicker hexToRGB:[self.specifier propertyForKey:@"tint"]];
	else return [UIColor colorWithRed:0.87 green:0.25 blue:0.40 alpha:1];
}

+(UIColor *)hexToRGB:(NSString *)hex {
  const char *cStr = [hex cStringUsingEncoding:NSASCIIStringEncoding];
  long x = strtol(cStr+1, NULL, 16);
  unsigned char r, g, b;
  b = x & 0xFF;
  g = (x >> 8) & 0xFF;
  r = (x >> 16) & 0xFF;
  return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
