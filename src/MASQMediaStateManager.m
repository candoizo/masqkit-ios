#import "MASQMediaStateManager.h"

@interface SBApplication : NSObject
-(NSString *)bundleIdentifier;
@end

@interface SBMediaController : NSObject
+(SBMediaController *)sharedInstance;
-(SBApplication *)nowPlayingApplication;
-(BOOL)isPlaying; // playing
-(BOOL)isPaused; // just paused
-(void) _mediaRemoteNowPlayingInfoDidChange:(id)arg1;
-(void)setNowPlayingInfo:(id)arg1; //called when it starts / cahnges
-(void)setNowPlayingProcessId:(id)arg1; //also called when started / changed
@end

@implementation MASQMediaStateManager
+(NSString *)playerBundleID {
  return [NSClassFromString(@"SBMediaController") sharedInstance].nowPlayingApplication.bundleIdentifier;
}
// static BOOL wantsUpdate;
// +(MASQMediaStateManager *)sharedManager {
//
// }
//
// +(BOOL)addInstanceObservers {
//   MASQMediaStateManager * m = MASQMediaStateManager.sharedManager;
//   for (NSString * lisKeys in m.listeners.allKeys)
//   {
//     for (NSString * cla in m.listeners.allKeys[lisKeys])
//     {
//       for (NSString * meth in classes[cla])
//       {
//         if (NSClassFromString(cla) respondsToSelector:@selector(sharedInstance))
//         if ([NSClassFromString(cla) sharedInstance])
//         [[NSClassFromString(cla) sharedInstance] addObserver:m forKeyPath:meth options:NSKeyValueObservingOptionNew context:nil];
//         else
//         {
//           HBLogError(@"Hey theres a problem with one, it needs a shared instance!");
//           return NO;
//         }
//       }
//     }
//   }
//   return YES;
// }
//
// - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//   MASQMediaStateManager * m = MASQMediaStateManager.sharedManager;
//   // first we check if the artwork has changed
//   if ([m.listeners[@"infoChanged"] containsObject:keyPath])
//   {
//     if (SBMediaController.nowPlayingProcessPID)
//     { // be safe by making sure it actually is still playing before looking to update
//       //set something that tells it we want to make sure the artwork gets updated
//       [MASQHousekeeper.prefs setBool:@YES forKey:@"artworkWantsUpdate"];
//       // probably gunna have to do some cfprefs stuf
//     }
//   }
//   // net we check if the app has died because
//   if ([m.listeners[@"stateChanged"] containsObject:keyPath])
//   {
//     //check to be sure there is an app
//     if (SBMediaController.nowPlayingProcessPID)
//     {
//       //still alive but paused? potentially gunna skip so
//     }
//     else
//     {
//       //set something to hide the artwork cus the app was killed
//     }
//   }
// }
//
// +(NSDictionary *)listeners {
//   return @{
//     @"infoChanged" : @
//     {
//       @"SBMediaController" : @[@"setNowPlayingInfo:", @"_mediaRemoteNowPlayingInfoDidChange"]
//     }
//     ,
//     @"stateChanged" : @
//     {
//       @"SBMediaController" : @[@"isPaused"]
//     }
//   }
// }
@end

// %ctor {
// 	@autoreleasepool {
// 		loadPreferences();
//
// 		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
// 			NULL,
// 			(CFNotificationCallback)prefsCallback,
// 			kSettingsChangedNotification,
// 			NULL,
// 			CFNotificationSuspensionBehaviorDeliverImmediately
// 		);
// 	}
// }
