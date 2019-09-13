#import <Preferences/PSListController.h>

@interface UIImage (Private)
+ (UIImage *)imageNamed:(id)img inBundle:(id)bndl;
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(int)scale;
@end

@interface UIView (Private)
-(BOOL)hasBackgroundEffect;
@end

@interface _UIVisualEffectViewBackgropCaptureGroup : NSObject
-(void)setDisableInPlaceFiltering:(BOOL)arg1;
@end

@interface UINavigationBar (Private)
// -(UIView *)backgroundView;
-(UIView *)currentBackButton;
-(void)_updateNavigationBarItemsForStyle:(int)arg1;
// @property (nonatomic) BOOL prefersLargeTitles;
@end

@interface UIBarButtonItem (Private)
-(UIView *)view;
@end

@interface UINavigationItem (Private)
-(UIBarButtonItem *)customRightItem;
@end

@interface MASQPrefsController : PSListController
@property (nonatomic, assign) int origStyle;
@property (nonatomic, assign) CAGradientLayer * origBar;
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
