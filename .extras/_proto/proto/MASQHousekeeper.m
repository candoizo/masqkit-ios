#import "MASQHousekeeper.h"

@implementation MASQHousekeeper
+ (instancetype)sharedPrefs {
    static dispatch_once_t once;
    static id prefs;
    dispatch_once(&once, ^{
        prefs = [[NSUserDefaults alloc] initWithSuiteName:@"ca.ndoizo.masq"];
        // [((NSUserDefaults *)prefs) registerDefaults:@{
           // @"CC" : @"Ripped@100",
           // @"LS" : @"Circled@100",
           // @"MP" : @"Vinyl@71"
           // @"CCStyle" : @2,
           // @"LSStyle" : @2,
        // }];
    });
    return prefs;
}

+(UIColor *)masqTintWithAlpha:(float)a {
  return [UIColor colorWithRed:0.87 green:0.25 blue:0.40 alpha:a];
}
@end
