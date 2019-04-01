#import "MASQThemeManager.h"
#import "MASQHousekeeper.h"

@implementation MASQThemeManager
+(NSBundle *)themeBundleForKey:(NSString *)arg1 {
  if (!arg1) return nil;

  NSUserDefaults * prefs = [NSClassFromString(@"MASQHousekeeper") sharedPrefs];
  HBLogDebug(@"prefs %@", prefs);
  NSString * themeId = nil;
  if ([prefs valueForKey:arg1]) {
    themeId = [prefs valueForKey:arg1];
    HBLogDebug(@"%@ : %@", themeId, [prefs valueForKey:arg1]);
    if (![themeId containsString:@"bundle"])
    {
      themeId = nil;
      HBLogDebug(@"Didnt contian bundle to overwriting the var to nil");
    }
  }
  HBLogDebug(@"so if theres a value for the key, it would be %@", themeId);
  if (!themeId && [self backingDict][arg1])
  themeId = [self backingDict][arg1];

  if (!themeId){
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

+(NSDictionary *)backingDict {
  return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleWithPath:@"/private/var/mobile/Library/Preferences/"] pathForResource:@"ca.ndoizo.masq" ofType:@"plist"]];
}
@end
