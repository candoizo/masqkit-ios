#import <Social/Social.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSwitchTableCell.h>
#import <Preferences/PSSegmentTableCell.h>
#import <Preferences/PSEditableTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <AudioToolbox/AudioToolbox.h>

//Definitions
#define kCustomTint                     [UIColor colorWithRed:0.87 green:0.25 blue:0.40 alpha:1.0] //pink
#define kCCTintColor                    [UIColor colorWithRed:0.50 green:0.42 blue:0.85 alpha:1.0] //#7f6bda indigoish
#define kLSTintColor                    [UIColor colorWithRed:0.00 green:0.48 blue:1.00 alpha:1.0] //#007AFF blueish
#define kMPTintColor 				    		  	[UIColor colorWithRed:0.91 green:0.31 blue:0.50 alpha:1.0] //#e8507f

//First Use Controller
#define kWelcomeText @"Welcome to MASQ²"
#define kIntroDesc @"A powerful artwork enhancer for iOS!"
#define kSectionOne @"Customize your look with creative themes from amazing designers"
#define kSectionTwo @"Peep your music at it's best without compromising performance"
#define kSectionThree @"Plugins let you bring the experience everywhere"
#define kTweet @"Im using Masq² by @candoizo, get the source at https://candoizo.gitlab.io/masq"

@interface UIColor  (Private)
+ (UIColor *)groupTableViewBackgroundColor;
+ (UIColor *)lightTextColor;
+ (UIColor *)darkTextColor;
@end

@interface UIImage (Private)
+ (UIImage *)imageNamed:(id)img inBundle:(id)bndl;
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(int)scale;
@end

@interface PSListController ()
- (void)clearCache;
@end

@protocol PreferencesTableCustomView
- (id)initWithSpecifier:(id)arg1;
@optional
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1;
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 inTableView:(id)arg2;
@end

@interface PSTableCell ()
- (id)initWithStyle:(int)style reuseIdentifier:(id)arg2;
@end

@interface PSListController ()
-(void)clearCache;
-(void)reload;
-(void)viewWillAppear:(BOOL)animated;
@end

@implementation UIImage (Masq)
+ (UIImage*)rotateImage:(UIImage*)sourceImage clockwise:(BOOL)clockwise {
    CGSize size = sourceImage.size;
    UIGraphicsBeginImageContext(CGSizeMake(size.height, size.width));
    [[UIImage imageWithCGImage:[sourceImage CGImage]
                         scale:1.0
                   orientation:clockwise ? UIImageOrientationRight : UIImageOrientationLeft]
                   drawInRect:CGRectMake(0,0,size.height ,size.width)];

   UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();

   return newImage;
  }
@end

@implementation UIColor (Masq)
+(UIColor *)averageColorOfImage:(UIImage*)image{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), image.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    if(rgba[3] > 0) {
        CGFloat alpha = ((CGFloat)rgba[3])/255.0;
        CGFloat multiplier = alpha/255.0;
        return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
                               green:((CGFloat)rgba[1])*multiplier
                                blue:((CGFloat)rgba[2])*multiplier
                               alpha:alpha];
    }else {
        return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
                               green:((CGFloat)rgba[1])/255.0
                                blue:((CGFloat)rgba[2])/255.0
                               alpha:((CGFloat)rgba[3])/255.0];
    }
}
@end
