#import <Preferences/PSListController.h>

@interface MASQPrefsController : PSListController
@property (nonatomic) NSUserDefaults * prefs;
+(void)clearPrefs;

-(UIBarButtonItem *)loveButton;
- (void)showLove;
-(UIImage *)imageFromPrefsWithName:(NSString *)n;

- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (id)tableView:(id)tableView viewForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(id)tableView heightForHeaderInSection:(NSInteger)section;
- (NSArray *)specifiers;
@end
