#import "MASQThemeContext.h"
#import "MASQContextCache.h"

@implementation MASQThemeContext
-(id)initWithBundle:(NSBundle *)arg1 {
  if (self = [super init] && arg1)
  {
    [self loadThemeInfo:arg1];
  }
  else
  HBLogError(@"Theme bundle was nil.");
  return self;
}

-(void)loadThemeInfo:(NSBundle *)arg1 {

  self.info = [NSMutableDictionary new];
  // NSString * info = [arg1 pathForResource:@"Info" ofType:@"plist"];

  NSURL * info = [NSURL fileURLWithPath:[arg1 pathForResource:@"Info" ofType:@"plist"]];

  NSError *error;
  if ([NSFileManager.defaultManager fileExistsAtPath:infoPath])
  { // A new theme!
    self.modernTheme = YES;
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:infoPath];

    self.info = dict;

    //
    // NSString * name = dict[@"name"];
    float ratio = [dict[@"ratio"] floatValue];
    self.ratio = ratio;
    //
    // BOOL darkMode = [dict[@"darkMode"] boolValue];
    // // parse assets
    //
    //
    // NSString * assets = dict[@"assets"];
    // if dark mode

    // top group

    // bottom group

  }
  else
  { // else it's an older theme, but it checks out sir

    NSString * themeName = theme.bundlePath.lastPathComponent;
    self.ratio = [[themeName componentsSeparatedByString:@"@"].lastObject floatValue] / 100;

    HBLogDebug(@"test %@", self.bundle.resourcePath);

    // get images
    NSURL * overlay = [self.bundle.resourceURL URLByAppendingPathComponent:@"Overlay.png"];
    NSURL * underlay = [self.bundle.resourceURL URLByAppendingPathComponent:@"Underlay.png"];
    NSURL * mask = [self.bundle.resourceURL URLByAppendingPathComponent:@"Overlay.png"];

    self.assets = [NSMutableArray new];


    if ([overlay checkResourceIsReachableAndReturnError:&error])
    [self.assets addObject:overlay];

    if ([overlay checkResourceIsReachableAndReturnError:&error])
    [self.assets addObject:underlay];

    if ([overlay checkResourceIsReachableAndReturnError:&error])
    [self.assets addObject:mask];

    // NSString * overlay = [NSString stringWithFormat:@"%@/Overlay.png", self.bundle.resourcePath];;
    // NSString * underlay = [NSString stringWithFormat:@"%@/Underlay.png", self.bundle.resourcePath];
    // NSString * mask = [NSString stringWithFormat:@"%@/Mask.png", self.bundle.resourcePath];
    //
    // self.assets = [NSMutableArray new];
    // if ([NSFileManager.defaultManager fileExistsAtPath:overlay])
    // [self.assets addObject:overlay];
    //
    // if ([NSFileManager.defaultManager fileExistsAtPath:underlay])
    // [self.assets addObject:underlay];
    //
    // if ([NSFileManager.defaultManager fileExistsAtPath:mask])
    // [self.assets addObject:mask];

  }

  if (self.assets.count > 0)
  [self cacheAssets];
}

-(void)cacheAssets {
  if (self.assets)
  { // check cache for existing assets
    // load ones that arent pre-existing
    for (NSURL * path in self.assets)
    {

      NSCache * cache = MASQContextCache.sharedInstance.cache;
      UIImage *image = [cache objectForKey:@(path.hash).stringValue];

      if (!image)
      { // if not in cache
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
          HBLogDebug(@"%@", path);
          NSData *imageData = [NSData dataWithContentsOfURL:path];
          HBLogError(@"AYY %@", imageData);
          if (imageData)
          {
            // Set image to cache
            self.testImage = [UIImage imageWithData:imageData];


            [cache setObject:imageData forKey:@(path.hash).stringValue];
            // [cache setObject:[UIImage imageWithData:imageData] forKey:@(path.hash).stringValue];
            dispatch_async(dispatch_get_main_queue(), ^{
              // [yourImageView setImage:[UIImage imageWithData:imageData]];
            });
          }
        });
      }
      else
      { // Use image from cache
        // [yourImageView setImage:image];
      }
    }
  }
}
@end
