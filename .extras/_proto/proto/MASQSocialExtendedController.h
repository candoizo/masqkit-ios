#import <Social/Social.h>

@interface UIImage (livate)
+ (UIImage *)imageNamed:(id)img inBundle:(id)bndl;
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(int)scale;
@end

@interface UILabel (sdivate)
-(void)sizeToFit;
@end

@interface SLComposeViewController (SLYIVATE)
@property (retain) UIViewController * remoteViewController;
+(instancetype)composeViewControllerForServiceType:(id)arg1;
@end

@interface MASQSocialExtendedController : SLComposeViewController
@property (nonatomic, assign) CGPoint showPoint;
@property (nonatomic, assign) CGPoint gonePoint;
@property (nonatomic, retain) UIView * platterView;
+(id)composeViewControllerForServiceType:(id)arg1;
-(id)topPlatter;
-(void)showPlatter;
-(void)dismissPlatter;
@end
