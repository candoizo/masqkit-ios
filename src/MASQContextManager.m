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

-(void)updatePlayback {
  if (NSClassFromString(@"AVAudioSession"))
  {
    AVAudioSession * audio = (AVAudioSession *)[NSClassFromString(@"AVAudioSession") sharedInstance];
    if (audio)
    { // we recieve the notication just before AVAudioSession is aware
      // to workaround this we flip the value
      BOOL isPlaying = [audio isOtherAudioPlaying];
      // fyi might need to reset activeAudio to nil when the now playing app is killed, but idk yet
      // new attempt that ignores the initial doublecall
      if (self.activeAudio == nil)
      {
        self.activeAudio = @(isPlaying);
        self.justSet = YES;
      }
      else if (self.justSet)
      {
        self.activeAudio = @(isPlaying);
        self.justSet = NO;
      }
      else
      self.activeAudio = @(isPlaying);

      if (!self.justSet)
      { // dont wanna call this twice
        NSMapTable * keyMap = self.keyMap;
        for (MASQArtworkView * test in keyMap)
        {
          test.activeAudio = [self.activeAudio boolValue];
          // setting this triggers tapAnimate
        }
      }

      return;

      // if (self.activeAudio == nil && !isPlaying)
      // { // if it has never been sent but we are getting this notifcation
      //   // then the audio must have just begun playing
      //   // the problem is only AVAudioSession has not seen that yet
      //   // but since we know it has to have started playing we force YES
      //   self.activeAudio = @(YES);
      //   self.justSet = YES;
      // }
      // else if (self.justSet && !isPlaying && self.activeAudio)
      // { // it would reset it to off but
      //   // so this notif is posted multiple times
      //   // and ios usually tricks us by finally sending a good one at the end
      //   // so we catch it this way
      //   self.activeAudio = @(isPlaying);
      //   self.justSet = NO;
      // }
      // else //perhaps need to check if inside an app and behave diff
      // self.activeAudio = @(isPlaying);
      //
      // // if (!self.justSet)
      // // { // ignore the shitfest above ;P
      //   NSMapTable * keyMap = self.keyMap;
      //   for (MASQArtworkView * test in keyMap)
      //   {
      //     test.activeAudio = [self.activeAudio boolValue];
      //
      //     // theres some other case that I should be pausing this i think
      //     // if (test.imageHost && test.wantsAnimation)
      //     // [test tapAnimate];
      //   }
      // }
    }
  }
}

-(void)registerObservers {
  NSNotificationCenter * def = NSNotificationCenter.defaultCenter;

  [def addObserver:self selector:@selector(updatePlayback)  name:@"_MRMediaRemotePlayerIsPlayingDidChangeNotification" object:nil];
  // [def addObserver:self selector:@selector(updatePlayback)  name:@"_MRMediaRemotePlayerPlaybackStateDidChangeNotification" object:nil];

  if (NSClassFromString(@"SBMediaController"))
  { // context is in SpringBoard, track LS/CC
    [def addObserver:self selector:@selector(updateTheme:)  name:@"SBControlCenterControllerWillPresentNotification" object:nil];
    [def addObserver:self selector:@selector(updateTheme:)  name:@"SBCoverSheetWillPresentNotification" object:nil];
  }
  else // probably in an app so update theme on open
  // [def addObserver:shared selector:@selector(updateThemes) name:UIApplicationDidBecomeActiveNotification object:nil];
  [def addObserver:self selector:@selector(updateThemes) name:UIApplicationWillEnterForegroundNotification object:nil];

  [def addObserver:self selector:@selector(removeObservers) name:UIApplicationWillTerminateNotification object:nil];
}

-(void)removeObservers {
  NSNotificationCenter * def = NSNotificationCenter.defaultCenter;

  [def removeObserver:self name:@"_MRMediaRemotePlayerIsPlayingDidChangeNotification" object:nil];
  // [def removeObserver:self name:@"_MRMediaRemotePlayerPlaybackStateDidChangeNotification" object:nil];

  if (NSClassFromString(@"SBMediaController"))
  {
    [def removeObserver:self name:@"SBControlCenterControllerWillPresentNotification" object:nil];
    [def removeObserver:self name:@"SBCoverSheetWillPresentNotification" object:nil];
  }
  else
  [def removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];

  [def removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}

-(void)updateTheme:(id)sender {
  NSString * poster = [sender name];
  NSMapTable * themes = self.themes;
  if ([poster isEqualToString:@"SBCoverSheetWillPresentNotification"])
  {
    // HBLogWarn(@"sender: %@", poster);
    NSString * identifier = @"LS";
    NSBundle * theme = [MASQThemeManager themeBundleForKey:identifier];
    if (theme != themes[identifier])
    {
      themes[identifier] = theme;
      [self updateIdentity:identifier];
    }
  }

  else if ([poster isEqualToString:@"SBControlCenterControllerWillPresentNotification"])
  {
    // HBLogWarn(@"sender: %@", poster);
    NSString * identifier = @"CC";
    NSBundle * theme = [MASQThemeManager themeBundleForKey:identifier];
    if (theme != themes[identifier])
    {
      themes[identifier] = theme;
      [self updateIdentity:identifier];
    }
  }
}

-(void)updateIdentity:(NSString *)arg1 {
  NSMapTable * keyMap = self.keyMap;
  for (MASQArtworkView * test in keyMap)
  { // for all views assigned a key
    NSString * val = keyMap[test];

    if ([val isEqualToString:arg1])
    { // if the value of the test object is one that wants updating
      [test updateTheme];
    }
  }
}

-(void)updateThemes {

  for (NSString * identifier in self.identities)
  { // for all identities being tracked
    NSBundle * theme = [MASQThemeManager themeBundleForKey:identifier];

    if (theme != self.themes[identifier])
    { // theme set in prefs is not equal to the last tracked one
      self.themes[identifier] = theme;
      [self updateIdentity:identifier];
    }
  }
}

-(void)registerView:(id)arg1 {

  if (arg1 && self.keyMap)
  {
    if ([arg1 respondsToSelector:@selector(identifier)])
    {
      NSString * identifier = [arg1 identifier];
      if (identifier)
      {
        NSMutableArray * identities = self.identities;
        if (![identities containsObject:identifier])
        {
          [identities addObject:identifier];

          // wasnt here earlier so lets preload this
          NSBundle * theme = [MASQThemeManager themeBundleForKey:identifier];
          [self.themes setObject:theme forKey:identifier];
        }
        [self.keyMap setObject:identifier forKey:arg1];
      }
    }
  }
}
@end
