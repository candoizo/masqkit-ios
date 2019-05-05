#import "MASQThemeManager.h"
// #import "MASQHousekeeper.h"

// @interface UIApplication (Private)
// -(NSString *)bundleIdentifier;
// @end

@implementation MASQThemeManager
+(id)prefs {
  static dispatch_once_t once;
  static id sprefs;
  dispatch_once(&once, ^
  {
    sprefs = [[NSUserDefaults alloc] initWithSuiteName:@"ca.ndoizo.masqkit"];
  });
  return sprefs;
}

+(NSBundle *)themeBundleForKey:(NSString *)arg1 {
  if (!arg1) return nil;

  NSUserDefaults * prefs = [NSClassFromString(@"MASQThemeManager") prefs];
  NSString * themeId = nil;
  if ([prefs valueForKey:arg1])
  themeId = [prefs valueForKey:arg1];

  // here where the problem where i lost updates on 3rd party apps arises
  /*
    basically first I was checking the prefs valueForKey:@"" and if I got a value from there I ignored the backingDict value, even though it could have been newer

    since the NSUserDefaults wasnt updated yet but still held the old value it wasnt updating. But once i exited a second time it usually had by then, and thats why it would give me a new one!

    Meanwhile it already updates intantly between prefs / sb so thats why it was updating immediately
  */
  // if the backingDict has a newer thing I shoul duse that
  // but probably only on iOS 11 because i wont be getting the instant updates on ios 10

  // so if there was no themeId we overwrite, but what if there was an old one?
  NSString * backingTheme = [self backingDict][arg1];
  if (!themeId && backingTheme)
  themeId = backingTheme;

  // if we're not in springboard and the old theme is different, we shoudl use it
  // HBLogWarn(@"UIBundle %@", UIApplication.sharedApplication.bundleIdentifier);
  // we check if we're in springboard because its the only one we can guaruntee
  // wont need to do this, since it stays synced with NSUserDefaults
  if (!NSClassFromString(@"SpringBoard") && backingTheme)
  {
    // HBLogWarn(@"not in springboard, backing dict %@ != %@", backingTheme, themeId);
    if (![themeId isEqualToString:backingTheme])
    { // this means it's an older themeid
      // HBLogWarn(@"The dict path was more updated!");
      if (!NSClassFromString(@"SBMediaController"))
      // if not in springboard we accept the path is probably correct
      themeId = [self backingDict][arg1];
    }
  }

  if (!themeId)
  { //error probably or not set.
    themeId = @"Default.bundle/Default@100";
  }
  NSURL * tPath = [[self themeDir] URLByAppendingPathComponent:themeId];
  return [NSBundle bundleWithURL:tPath];
}

+(NSURL *)themeDir {
  return [NSURL fileURLWithPath:@"/Library/Application Support/MASQ/Themes"];
}

+(NSDictionary *)backingDict {
  return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleWithPath:@"/private/var/mobile/Library/Preferences/"] pathForResource:@"ca.ndoizo.masqkit" ofType:@"plist"]];
}

// +(UIColor *)hexToRGB:(NSString *)hex {
//   const char *cStr = [hex cStringUsingEncoding:NSASCIIStringEncoding];
//   long x = strtol(cStr+1, NULL, 16);
//   unsigned char r, g, b;
//   b = x & 0xFF;
//   g = (x >> 8) & 0xFF;
//   r = (x >> 16) & 0xFF;
//   return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
// }
@end
