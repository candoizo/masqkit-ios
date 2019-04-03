#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface MASQThemePicker : PSViewController <UITableViewDataSource, UITableViewDelegate>
@property () NSUserDefaults * prefs;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *themes;
@property (nonatomic, retain) NSString *selectedTheme;
@property (nonatomic, retain) NSIndexPath *checkedIndexPath;

-(NSString *)themeKey; // MP, CC, SP, LS, SC,
-(UIColor *)themeTint;
-(NSString *)themePath;
+(UIColor *)hexToRGB:(NSString *)arg1;
@end
