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
  if (themeId) HBLogWarn(@"Prefs had a value, and it was %@", themeId);

  // here where the problem where i lost updates on 3rd party apps arises
  /*
    basically first I was checking the prefs valueForKey:@"" and if I got a value from there I ignored the backingDict value, even though it could have been newer

    since the NSUserDefaults wasnt updated yet but still held the old value it wasnt updating. But once i exited a second time it usually had by then, and thats why it would give me a new one!

    Meanwhile it already updates intantly between prefs / sb so thats why it was updating immediately
  */
  // if the backingDict has a newer thing I shoul duse that
  // but probably only on iOS 11 because i wont be getting the instant updates on ios 10
  if (!themeId && [self backingDict][arg1])
  themeId = [self backingDict][arg1];

  if ([self backingDict][arg1])
  {
    if (![themeId isEqualToString:[self backingDict][arg1])]
    {
      HBLogWarn(@"Hey these are different! %@ != %@", themeId, [self backingDict][arg1]);
      HBLogWarn(@"if on ios 11, then the hard dict path will be more updated");
    }
  }

  if (!themeId)
  { //error probably
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
