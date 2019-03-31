#import "MASQThemeManager.h"
#import "MASQHousekeeper.h"

@implementation MASQThemeManager
+(NSBundle *)themeBundleForKey:(NSString *)arg1 {
  if (!arg1) return nil;

  NSUserDefaults * prefs = [NSClassFromString(@"MASQHousekeeper") sharedPrefs];
  NSString * themeId = nil;
  if ([prefs valueForKey:arg1])
  themeId = [prefs valueForKey:arg1];
  else if ([self directDict][arg1])
  themeId = [self directDict][arg1];
  else {
    HBLogError(@"No key found.");
    return nil;
  }

  NSURL * tPath = [[self themeDir] URLByAppendingPathComponent:themeId];
  return [NSBundle bundleWithURL:tPath];
}

+(NSURL *)themeDir {
  return [NSURL fileURLWithPath:@"/Library/Application Support/MASQ/Themes"];
}

+(NSDictionary *)directDict {
  return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleWithPath:@"/private/var/mobile/Library/Preferences/"] pathForResource:@"ca.ndoizo.masq" ofType:@"plist"]];
}
@end
