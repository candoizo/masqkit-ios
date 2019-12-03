@interface MASQContextCache : NSObject
@property (nonatomic, retain) NSCache * cache;
+(MASQContextCache *)sharedInstance;
-(void)prepareCache;
-(void)loadTheme:(NSBundle *)arg1;
@end
