@interface MASQImageAnalyzer : NSObject
@property (nonatomic, retain) NSDictionary * cache;
@property (nonatomic, retain) id imageDelegate;
// @property (nonatomic, readonly) NSArray * info;
// @property (nonatmoic, readonly) UIColor * primary;
// @property (nonatomic, readonly) UIColor * secondary;
// @property (n;onatomic, readonly) UIColor * tertiary;
// +(instancetype)sharedInstance;

// -(void)processActiveImage ;
// -(UIImage *)activeImage;
// -(void)updatePixelInfo;
// -(NSArray *)pixelInfo;
@end

@interface UIColor (Private)
-(CGFloat)redComponent;
-(CGFloat)greenComponent;
-(CGFloat)blueComponent;
@end
