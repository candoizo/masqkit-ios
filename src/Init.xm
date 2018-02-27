#import "dlfcn.h"
#import "MASQThemeManager.h"


// @property () MPArtworkCatalog * artworkCatalog;
 /*
  use MPArtworkCatalog's -(UIImage *)bestImageFromDisk
  can try to use the existing objects, or even try to make my own with
  MPArtworkCatalog * catalog = [MPArtworkCatalog _artworkCacheForIdentifier:@"MASQCache" requestingContext:self]
*/

%ctor {
  HBLogDebug(@"MASQKit loaded into bundle: %@", NSBundle.mainBundle.bundleIdentifier);

  // [[[NSUserDefaults alloc] initWithSuiteName:@"ca.ndoizo.masq"] registerDefaults:@{
  //    @"CC" : @"Ripped@100",
  //    @"LS" : @"Circled@100",
  //    @"MP" : @"Vinyl@71",
  // }];

    // if (![MASQThemeManager.sharedPrefs boolForKey:@"setupMasq"]) {
    //   //create paths
    // }
    // NSArray * plugins = [MASQThemeManager.mainBundle pathsForResourcesOfType:@".dylib" inDirectory:@"Plugins"];
    // if (!plugins) {
    //   HBLogDebug(@"No plugins detected.");
    // }
    // else {
    //   NSArray *filters = [MASQThemeManager.mainBundle pathsForResourcesOfType:@".plist" inDirectory:@"Plugins"];
    //   HBLogDebug(@"Plugin's detected, lookds like %@. Filters are %@", plugins, filters);
    //     for (NSString * p in plugins) {
    //       //for each plugin, if matching filter
    //       NSString * filter = [NSString stringWithFormat:@"%@.plist", p.stringByDeletingPathExtension];
    //       NSString * cont = [NSString stringWithContentsOfFile:filter encoding:0 error:nil];
    //       NSString * bundle = [[cont componentsSeparatedByString:@"Bundles = ( \""].lastObject componentsSeparatedByString:@"\""].firstObject;
    //       if ([NSBundle.mainBundle.bundleIdentifier isEqualToString:bundle]) {
    //         dlopen(p.UTF8String, RTLD_NOW);
    //         HBLogDebug(@"dlopened p %@ in %@", p, NSBundle.mainBundle.bundleIdentifier);
    //       }
    //     }
    // }
}
