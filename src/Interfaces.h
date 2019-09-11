#import "Private.h"

@interface SBApplication : UIApplication
-(NSString *)bundleIdentifier;
@end

@interface SBMediaController : NSObject
+(SBMediaController *)sharedInstance;
-(SBApplication *)nowPlayingApplication;
-(BOOL)hasTrack;
@end

@interface SBLockStateAggregator : NSObject
+(instancetype)sharedInstance;
-(int)lockState;
@end

@interface SBCoverSheetPresentationManager
+(id)sharedInstance;
-(BOOL)isVisible;
-(void)setCoverSheetPresented:(BOOL)arg1 animated:(BOOL)arg2 withCompletion:(id)arg3;
@end
