@interface MASQArtworkView : UIView
@property (nonatomic, assign) BOOL disabled;
-(id)initWithThemeKey:(NSString *)arg1 frameHost:(UIView *)arg2 imageHost:(UIImageView *)arg3;
@end

%ctor { // make sure dylibs are loaded in before hooks
    dlopen("/Library/MobileSubstrate/DynamicLibraries/your.tweak.dylib", RTLD_NOW);
    if (!%c(MASQArtworkView)) dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
}
