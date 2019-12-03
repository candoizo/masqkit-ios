#import "MASQContextCache.h"
#import "MASQContextManager.h"

static MASQContextCache * shared;

@implementation MASQContextCache

+(MASQContextCache *)sharedInstance {
  static dispatch_once_t once;
  dispatch_once(&once, ^
  {
    shared = [[MASQContextCache alloc] init];
    [shared prepareCache];
  });
  return shared;
}

-(void)prepareCache
{
  self.cache = [[NSCache alloc] init];
}

-(void)loadTheme:(NSBundle *)arg1 {

  // get images to load
  //
  // NSBundle * theme = arg1;





}

// add listener to sharedInstance updateTheme / updateThemes / updateIdentity

// watch MASQContextManager for updates?

//
//   NSURL *url = [NSURL URLWithString:@"http://i1.ytimg.com/vi/YbT0xy_Jai0/maxresdefault.jpg"];
//   NSData * data = [NSData dataWithContentsOfURL:url];
//
//   UIImage *image [[UIImage alloc] initWithData:data];
//
//   NSString * path = url.path;
//
//   if (!self.cache[path])
//   {
//
//   }
//
// }
  // read MASQContextManager for identities
  // if ()

//

// NSString * imagePath =
//
// NSURL *url = [NSURL URLWithString:@"http://i1.ytimg.com/vi/YbT0xy_Jai0/maxresdefault.jpg"];
// NSData *data = [NSData dataWithContentsOfURL:url];
// UIImage *image = [[UIImage alloc] initWithData:data];
//
// NSString *
//
//
// NSString *imagePath = @"http://i1.ytimg.com/vi/YbT0xy_Jai0/maxresdefault.jpg";
// //    UIImage *image;
// if (!(image = [cache objectForKey:imagePath])) { // always goes inside condition
//     // Cache miss, recreate image
//     image = [[UIImage alloc] initWithData:data];
//     if (image) {    // Insert image in cache
//         [cache setObject:image forKey:imagePath]; // cache is always nil
//     }
// }
// _imgCache.image = image;

@end
