// #import <Preferences/PSListController.h>
#import "MASQBaseController.h"

// @interface UIImage (Private)
// + (UIImage *)imageNamed:(id)img inBundle:(id)bndl;
// + (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(int)scale;
// @end

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

@interface MASQPrefsController : MASQBaseController
// @property (nonatomic) NSUserDefaults * prefs;
// @property (nonatomic, assign) int origStyle;

- (void)viewDidLoad;
- (void)prepareBar;
- (NSArray *)specifiers;
@end
