#import "../MASQArtworkView.h"

#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface MPMediaItemArtwork : NSObject
-(UIImage *)imageWithSize:(CGSize)arg1;
@end

@interface MPConcreteMediaItemArtwork : MPMediaItemArtwork
@end

@interface MPMediaItem : NSObject
-(MPConcreteMediaItemArtwork *)artwork;
@end

@interface MPMusicPlayerController : NSObject
+(instancetype)systemMusicPlayer;
+(instancetype)applicationMusicPlayer;
-(MPMediaItem *)nowPlayingItem;
@end

@interface MASQThemePicker : PSViewController <UITableViewDataSource, UITableViewDelegate>
@property () NSUserDefaults * prefs;
@property (nonatomic, assign) NSString * hah;
@property () CFFileDescriptorRef queue;
@property (nonatomic, assign) int fd;
@property (nonatomic, retain) UIImageView * stylePreview;
@property (nonatomic, retain) MASQArtworkView * artwork;
@property (nonatomic, retain) MASQArtworkView * artworkd;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *themes;
@property (nonatomic, retain) NSString *selectedTheme;
@property (nonatomic, retain) NSIndexPath *checkedIndexPath;

-(NSString *)themeKey; // MP, CC, SP, LS, SC,
-(UIColor *)themeTint;
-(NSString *)themePath;
+(UIColor *)hexToRGB:(NSString *)arg1;

-(void)popMissingAlert;
-(void)wantsStyle:(BOOL)arg1;

// -(void)kqueueFired;
@end
