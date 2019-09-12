#import <Preferences/PSListController.h>


@interface UIView (Private)
-(BOOL)hasBackgroundEffect;
@end

@interface UINavigationBar (Private)
// -(UIView *)backgroundView;
@end

@interface UIBarButtonItem (Private)
-(UIView *)view;
@end

@interface UINavigationItem (Private)
-(UIBarButtonItem *)customRightItem;
@end

@interface MASQPrefsController : PSListController
@property (nonatomic) NSUserDefaults * prefs;
+(void)clearPrefs;

// -(UIBarButtonItem *)loveButton;
// - (void)showLove;
-(UIImage *)imageFromPrefsWithName:(NSString *)n;

- (void)viewDidLoad;
- (void)prepareBar;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (id)tableView:(id)tableView viewForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(id)tableView heightForHeaderInSection:(NSInteger)section;
- (NSArray *)specifiers;

@end
