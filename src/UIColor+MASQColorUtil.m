#import "UIColor+MASQColorUtil.h"

@implementation UIColor (MASQColorUtil)

+(UIColor *)_masq_hexToRGB:(NSString *)hex {
  const char *cStr = [hex cStringUsingEncoding:NSASCIIStringEncoding];
  long x = strtol(cStr+1, NULL, 16);
  unsigned char r, g, b;
  b = x & 0xFF;
  g = (x >> 8) & 0xFF;
  r = (x >> 16) & 0xFF;
  return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}

@end
