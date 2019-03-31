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

+(UIColor *)hexToRGB:(NSString *)hex {
  const char *cStr = [hex cStringUsingEncoding:NSASCIIStringEncoding];
  long x = strtol(cStr+1, NULL, 16);
  unsigned char r, g, b;
  b = x & 0xFF;
  g = (x >> 8) & 0xFF;
  r = (x >> 16) & 0xFF;
  return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}
@end
