@interface MASQThemeContext : NSObject
@property (nonatomic, assign) bool modernTheme;
@property (nonatomic, assign) float ratio;
@property (nonatomic, retain) NSBundle * bundle;
@property (nonatomic, retain) NSMutableArray * assets;
@property (nonatomic, retain) NSDictionary * info;
@property (nonatomic, retain) UIImage * testImage;
-(id)initWithBundle:(NSBundle *)arg1;
-(void)loadThemeInfo:(NSBundle *)arg1;
@end
