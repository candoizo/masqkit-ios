#import "MASQThemePicker.h"
#import "../src/MASQThemeManager.h"

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
  self.tableView.rowHeight = 65.0f;
	self.tableView.tintColor = [self themeTint];
	[self.view addSubview:self.tableView];
}

- (void)updateThemeList {
	 // create the theme list, starting with the default theme
	// NSMutableArray *themes = [@[@{@"bundle":@"Disabled@100", @"name":@"Disabled", @"scale":@"100"}] mutableCopy];
	NSMutableArray * themes = [NSMutableArray new];
	NSString * themePath = [self themePath];
	HBLogDebug(@"Theme path: %@", [self themePath]);
	// for all the installed bundles in /Application Support/MASQ/Themes/x.bundle
	for (NSString * bundles in [NSFileManager.defaultManager contentsOfDirectoryAtPath:themePath error:nil])
	{
		// Path to theme bundle
		NSString * tbPath = [NSString stringWithFormat:@"%@/%@", themePath, bundles];
		HBLogDebug(@"tbPath: %@", tbPath);
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
				[themes insertObject:@{ @"bundle":bthemeId, @"name":name, @"scale":scale, @"author":@""} atIndex:0];

				else //if not the default add normally
				[themes addObject:@{ @"bundle":bthemeId, @"name":name, @"scale":scale, @"author":@""}];
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
	self.themes = themes;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

		HBLogDebug(@"self.selectedTheme %@", self.selectedTheme);
		[self.prefs setValue:self.selectedTheme forKey:[self themeKey]];

		Class _cfx = NSClassFromString(@"_CFXPreferences");
		if ([_cfx respondsToSelector:@selector(flushCachesForAppIdentifier:user:)])
		{
			_CFXPreferences *prefs = [_cfx copyDefaultPreferences];
			[prefs flushCachesForAppIdentifier:(__bridge CFStringRef)@"ca.ndoizo.masq" user:(__bridge CFStringRef)@"/User"];
		}
	}
}

- (void)viewWillAppear:(BOOL)animated {
	 [super viewWillAppear:animated];
	 self.navigationController.navigationController.navigationBar.tintColor = [self themeTint];
	 [self updateThemeList];
}

- (void)viewWillDisappear:(BOOL)animated {
	self.navigationController.navigationController.navigationBar.tintColor = nil;
	[super viewWillDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.themes.count;
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
@end
