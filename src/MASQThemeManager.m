#import "MASQThemeManager.h"
#import "MASQHousekeeper.h"

@implementation MASQThemeManager
+(NSBundle *)themeBundleForKey:(NSString *)arg1 {
  if (!arg1) return nil;

  NSUserDefaults * prefs = [NSClassFromString(@"MASQHousekeeper") sharedPrefs];
  NSString * themeId = nil;
  NSDictionary * dir = [self directDict];
  HBLogDebug(@"dir %@, %@", dir, dir[arg1]);
  if (!themeId && [prefs valueForKey:arg1]) {
    themeId = [prefs valueForKey:arg1];
    if (![themeId containsString:@"bundle"]) themeId = nil;
  }

  if (!themeId && dir[arg1])
  themeId = dir[arg1];
  else {
    HBLogError(@"No key found.");
    return nil;
  }
  HBLogDebug(@"themeID %@", themeId);

  NSURL * tPath = [[self themeDir] URLByAppendingPathComponent:themeId];
  HBLogDebug(@"tpath%@", tPath);
  return [NSBundle bundleWithURL:tPath];
}

+(NSURL *)themeDir {
  return [NSURL fileURLWithPath:@"/Library/Application Support/MASQ/Themes"];
}

+(NSDictionary *)directDict {
  return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleWithPath:@"/private/var/mobile/Library/Preferences/"] pathForResource:@"ca.ndoizo.masq" ofType:@"plist"]];
}
@end
