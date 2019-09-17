#import "MASQContextManager.h"
#import "MASQThemeManager.h"
#import "MASQArtworkView.h"

static MASQContextManager * shared;

@implementation MASQContextManager
+(MASQContextManager *)sharedInstance {
  static dispatch_once_t once;
  dispatch_once(&once, ^
  {
    shared = [[MASQContextManager alloc] init];
    shared.identities = [NSMutableArray new];
    shared.themes = [NSMapTable weakToWeakObjectsMapTable];
    shared.keyMap = [NSMapTable weakToWeakObjectsMapTable];

    [shared registerObservers];
  });
  return shared;
}

-(void)registerObservers {
  NSNotificationCenter * def = NSNotificationCenter.defaultCenter;
  [def addObserver:shared selector:@selector(updateThemes) name:UIApplicationDidBecomeActiveNotification object:nil];

  if (NSClassFromString(@"SBMediaController"))
  { // context is in SpringBoard

    [def addObserver:self selector:@selector(updateTheme:)  name:@"SBControlCenterControllerWillPresentNotification" object:nil];

    [def addObserver:self selector:@selector(updateTheme:)  name:@"SBCoverSheetWillPresentNotification" object:nil];
  }
}

-(void)updateTheme:(id)sender {
  NSString * poster = [sender name];
  // HBLogWarn(@"sender: %@", poster);
  if ([poster isEqualToString:@"SBCoverSheetWillPresentNotification"])
  {
    // HBLogWarn(@"sender: %@", poster);
    NSString * identifier = @"LS";
    NSBundle * theme = [MASQThemeManager themeBundleForKey:identifier];
    if (theme != shared.themes[identifier])
    shared.themes[identifier] = theme;
    [shared updateIdentity:identifier];
    // so I do want to
    // [self updateThemes];
  }

  else if ([poster isEqualToString:@"SBControlCenterControllerWillPresentNotification"])
  {
    // HBLogWarn(@"sender: %@", poster);
    NSString * identifier = @"CC";
    NSBundle * theme = [MASQThemeManager themeBundleForKey:identifier];
    if (theme != shared.themes[identifier])
    shared.themes[identifier] = theme;
    [shared updateIdentity:identifier];
    // [self updateThemes];
  }
}

-(void)updateIdentity:(NSString *)arg1 {

  for (id test in shared.keyMap)
  { // for all views assigned a key
    NSString * val = shared.keyMap[test];

    if ([val isEqualToString:arg1])
    { // if the value of the test object is one that wants updating
      if ([NSBundle.mainBundle.bundleIdentifier isEqualToString:@"com.apple.springboard"])
      HBLogWarn(@"I believe I want to update! %@", test);
      [test updateTheme];
    }
  }
}

-(void)updateThemes {

  for (NSString * identifier in shared.identities)
  { // for all identities being tracked
    NSBundle * theme = [MASQThemeManager themeBundleForKey:identifier];
    if (theme != shared.themes[identifier])
    { // theme set in prefs is not equal to the last tracked one
      shared.themes[identifier] = theme;

      [shared updateIdentity:identifier];
      // if the active key is not marked as dirty we add it
      // if (![shared.dirtyKeys containsObject:identifier])
      // [shared.dirtyKeys addObject:identifier];


      // or maybe I can just avoid extra for loops

      // for every view traking the dirty key
      // for (id test in shared.keyMap)
      // { // for all views assigned a key
      //   NSString * val = shared.keyMap[test];
      //   if ([val isEqualToString:identifier])
      //   { // if the value of the test object is one that wants updating
      //     HBLogWarn(@"I believe I want to update!");
      //     [test updateTheme];
      //   }
      // }
      // well we update the theme and
    }

  }

  // for (NSString * key in shared.dirtyKeys)
  // { // for themes that need updating
  //   for (id test in shared.keyMap)
  //   { // for all views assigned a key
  //     NSString * val = shared.keyMap[test];
  //     if ([val isEqualToString:key])
  //     { // if the value of the test object is one that wants updating
  //       HBLogWarn(@"I believe I want to update!");
  //       [test updateTheme];
  //     }
  //   }
  //   [shared.dirtyKeys removeObject:key];
  // }
}

-(void)registerView:(id)arg1 {

  if (arg1 && shared.keyMap)
  {
    if ([arg1 respondsToSelector:@selector(identifier)])
    {
      NSString * identifier = [arg1 identifier];
      if (identifier)
      {
        if (![shared.identities containsObject:identifier])
        {
          [shared.identities addObject:identifier];

          // wasnt here earlier so lets preload this
          NSBundle * theme = [MASQThemeManager themeBundleForKey:identifier];
          [self.themes setObject:theme forKey:identifier];
        }

        // [shared.managedViews addObject:arg1];
        // NSString * addr = [NSString stringWithFormat:@"%p",arg1];
        // HBLogWarn(@"%p %@", arg1,addr);
        [shared.keyMap setObject:identifier forKey:arg1];
        // preload the theme while the otheer view inits
        // [self.themes addObject:theme];
        // self.

      }
    }
  }
}

-(void)updateIdentities {
  // if ()
}
@end
