#import "MASQThemeManager.h"

@implementation MASQThemeManager
+ (instancetype)sharedPrefs {
    static dispatch_once_t once;
    static id prefs;
    dispatch_once(&once, ^{
        prefs = [[NSUserDefaults alloc] initWithSuiteName:@"ca.ndoizo.masq"];
        [((NSUserDefaults *)prefs) registerDefaults:@{
           @"CC" : @"Ripped@100",
           @"LS" : @"Circled@100",
           @"MP" : @"Vinyl@71",
           @"CCStyle" : @2,
        }];
    });
    return prefs;
}
@end
