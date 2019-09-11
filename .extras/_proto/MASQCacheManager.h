@interface MASQCacheManager : NSObject
-(void)predictBuild; // run at init to get the active keys
/* tries to predict the future requests into a cache
  okay so just look at like
  chec MASQSettings.bundle/Prefs/*

  gather all the possible theme keys
  check if they have any
*/
-(NSBundle *)themeForKey:(NSString *)arg1;
-(NSArray *)artworkViewCache; //i could make it so whenever something requests from me, i add it to the cache of things

@end
