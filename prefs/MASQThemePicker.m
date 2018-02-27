#import "PrefUtils.h"
#import "MASQThemePicker.h"
#import "../src/MASQThemeManager.h"

@implementation MASQThemePicker
- (instancetype)init {
	if (self = [super init]) {
		self.prefs = [NSClassFromString(@"MASQThemeManager") sharedPrefs];
		self.title = @"Themes";
		_imageCache = [[NSCache alloc] init];
		_queue = [[NSOperationQueue alloc] init];
		_queue.maxConcurrentOperationCount = 3;
 	}
	return self;
}

-(NSString *)themeKey {
  return [[self specifier] propertyForKey:@"themeKey"];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	_selectedTheme = [self.prefs valueForKey:[self themeKey]];
  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.rowHeight = 65.0f;
	[self.view addSubview:self.tableView];
}

-(NSString *)themePath {
  return @"/Library/Application Support/MASQ/Themes";
}

-(UIColor *)themeTint {
	UIColor * themeTint = nil;
	if ([[self themeKey] isEqualToString:@"LS"]) themeTint = kLSTintColor;
	else if ([[self themeKey] isEqualToString:@"CC"]) themeTint = kCCTintColor;
	else if ([[self themeKey] isEqualToString:@"MP"]) themeTint = kMPTintColor;
	return themeTint;
}

- (void)updateThemeList {
	 // create the theme list, starting with the default theme
	 NSMutableArray *themes = [@[@{@"bundle":@"Default@100", @"name":@"Default", @"scale":@"100"}] mutableCopy];

	 //collect them from theme directory
    for (NSString * path in [NSFileManager.defaultManager contentsOfDirectoryAtPath:[self themePath] error:nil]) {
        NSArray * theme = [path componentsSeparatedByString:@"@"];
    		NSString *named = theme.firstObject;
    		NSString *scaling = theme.lastObject;

				NSString *credit = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/Credit.txt", [self themePath], path] encoding:NSUTF8StringEncoding error:nil];
				[themes addObject:@{ @"bundle":path, @"name":named, @"scale":scaling, @"author":credit ?: @""}];
    }

	 self.themes = themes;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ThemeCell"];
  cell.tintColor = [self themeTint];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.accessoryType = UITableViewCellAccessoryNone;

  // thumbnail
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 50, 50)];
  imageView.opaque = YES;
  imageView.backgroundColor = UIColor.whiteColor;
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  [cell.contentView addSubview:imageView];

  // title
  UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 20, cell.contentView.bounds.size.width - 78, 20)];
  titleLabel.opaque = YES;
  titleLabel.font = [UIFont systemFontOfSize:15];
  titleLabel.textColor = UIColor.blackColor;
  titleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
  [cell.contentView addSubview:titleLabel];

  //credit
	UILabel * creditLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 20, cell.contentView.bounds.size.width - 78, 70)];
	creditLabel.opaque = YES;
	creditLabel.font = [UIFont systemFontOfSize:8];
	creditLabel.textColor = UIColor.darkGrayColor;
	creditLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
	[cell.contentView addSubview:creditLabel];


	NSDictionary *themeInfo = self.themes[indexPath.row];
	titleLabel.text = themeInfo[@"name"];
	if (themeInfo[@"author"]) creditLabel.text = themeInfo[@"author"];
	// get thumbnail from cache, or create and cache new one
	NSString *path = [themeInfo[@"name"] isEqualToString:@"Default"] ?
	@"/Library/PreferenceBundles/MASQPrefs.bundle/Default.png"
	:
	[NSString stringWithFormat:@"%@/%@/Icon.png", [self themePath], themeInfo[@"bundle"]];

  imageView.image = [self.imageCache objectForKey:path] ?: [UIImage imageWithContentsOfFile:path];


  // do we know which row should be checked?
    if (!self.checkedIndexPath) {
    		// not yet; is it this row?
    		if ([themeInfo[@"bundle"] isEqualToString:self.selectedTheme]) {
    			self.checkedIndexPath = indexPath;
    		}
    }

    if ([indexPath isEqual:self.checkedIndexPath]) {
    		cell.accessoryType = UITableViewCellAccessoryCheckmark;
    	} else {
    		cell.accessoryType = UITableViewCellAccessoryNone;
    }

	return cell;

}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if (!(cell.accessoryType == UITableViewCellAccessoryCheckmark)) {
		// un-check previously checked cell
		UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.checkedIndexPath];
		oldCell.accessoryType = UITableViewCellAccessoryNone;
		// check this cell
    cell.tintColor = [self themeTint];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		self.checkedIndexPath = indexPath;

		NSDictionary *themeInfo = self.themes[indexPath.row];
		// save selection to prefs
		self.selectedTheme = themeInfo[@"bundle"];
		[self.prefs setValue:self.selectedTheme forKey:[self themeKey]];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	 [super viewWillAppear:animated];
	 self.navigationController.navigationController.navigationBar.tintColor = [self themeTint];
	 [self updateThemeList];
}

- (void)viewWillDisappear:(BOOL)animated {
	// un-tint navbar
	[self updateThemeList];
	self.navigationController.navigationController.navigationBar.tintColor = nil;
	// empty the thumbnail cache
	[self.imageCache removeAllObjects];
	[super viewWillDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.themes.count;
}

- (void)didReceiveMemoryWarning {
	[self.imageCache removeAllObjects];
	[super didReceiveMemoryWarning];
}
@end
