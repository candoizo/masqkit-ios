#import "Preferences/PSListController.h"
#import "../Private.h"

@interface MASQBaseController : PSListController
@property (nonatomic, assign) int barStyle;
@property (nonatomic, retain) NSUserDefaults * prefs;
+(void)clearPrefs;

-(void)loadView;
-(void)viewDidLoad;
-(void)viewWillAppear:(BOOL)arg1;
-(void)viewWillDisappear:(BOOL)arg1;

-(UIImage *)imageFromBundle:(NSString *)arg1;
-(NSArray *)sortRuleByKey:(NSString *)arg1;

-(UINavigationBar *)bar;
-(void)wantsStyle:(BOOL)arg1;
@end
