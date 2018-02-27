#import <Preferences/PSListController.h>
#import <Preferences/PSListItemsController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSSwitchTableCell.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSegmentTableCell.h>

@interface MASQThemePicker : PSViewController <UITableViewDataSource, UITableViewDelegate>
@property () NSUserDefaults * prefs;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *themes;
@property (nonatomic, strong) NSString *selectedTheme;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSCache *imageCache;
@property (nonatomic, strong) NSIndexPath *checkedIndexPath;

-(NSString *)themeKey; // MP, CC, SP, LS, SC,
-(UIColor *)themeTint;
-(NSString *)themePath;
@end
