#import "MASQThemeManager.h"
// #import "MASQHousekeeper.h"

@implementation MASQThemeManager
+(id)prefs {
  static dispatch_once_t once;
  static id sprefs;
  dispatch_once(&once, ^
  {
    sprefs = [[NSUserDefaults alloc] initWithSuiteName:@"ca.ndoizo.masq"];
  });
  return sprefs;
}

+(NSBundle *)themeBundleForKey:(NSString *)arg1 {
  if (!arg1) return nil;

  NSUserDefaults * prefs = [NSClassFromString(@"MASQThemeManager") prefs];
  NSString * themeId = nil;
  if ([prefs valueForKey:arg1])
  themeId = [prefs valueForKey:arg1];
  if (!themeId && [self backingDict][arg1])
  themeId = [self backingDict][arg1];

  if (!themeId){
    // HBLogError(@"No key found.");
    // return nil;
    themeId = @"Default.bundle/Default@100";
  }
  NSURL * tPath = [[self themeDir] URLByAppendingPathComponent:themeId];
  return [NSBundle bundleWithURL:tPath];
}

+(NSURL *)themeDir {
  return [NSURL fileURLWithPath:@"/Library/Application Support/MASQ/Themes"];
}

+(NSDictionary *)backingDict {
  return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleWithPath:@"/private/var/mobile/Library/Preferences/"] pathForResource:@"ca.ndoizo.masq" ofType:@"plist"]];
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
