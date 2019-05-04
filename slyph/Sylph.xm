@interface MASQArtworkView : UIView
-(id)initWithThemeKey:(NSString *)arg1 frameHost:(id)arg2 imageHost:(id)arg3;
@end

@interface SBDashBoardMediaControlsViewController : UIViewController
@property (nonatomic, retain) MASQArtworkView * masqSylph;
-(id)bigBoi;
-(void)addMasq;
@end

%hook SBDashBoardMediaControlsViewController
%property (nonatomic, retain) MASQArtworkView * masqSylph;

// -(id)bigBoi {
//   UIImageView * orig = %orig;
//   if (orig && !self.masqSylph)
//   { //if not yet added to Sylph, we will do so
//     [self addMasq];
//   }
//   return orig;
// }

-(void)viewDidLayoutSubview {
  %orig;
  if (!self.masqSylph) [self addMasq];
  else HBLogWarn(@"there is a sylph masq tho");
}

%new
-(void)addMasq {
  UIImageView * bigboi = [self bigBoi];
  if (bigboi)
  {
    MASQArtworkView * art = [[%c(MASQArtworkView) alloc] initWithThemeKey:@"LS" frameHost:bigboi imageHost:bigboi];
    self.masqSylph = art;
    [self.view addSubview:art];
    bigboi.hidden = YES;
  }
}

-(void)setBigBoi:(id)arg1
{
  %orig;
  if (!self.masqSylph)
  [self addMasq];
}

// -(void)updateBigBoi {
//   %orig;
//   if (!self.masqSylph) [self addMasq];
// }

%end

%ctor
{ // check that the kit has been loaded into the app we're hooking first
  if (!%c(MASQThemeManager))
  dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
  // load in the tweak we're extending so we can hook it
  dlopen("/Library/MobileSubstrate/DynamicLibraries/Slyph.dylib", RTLD_NOW);
  %init; //initialize our extension mods!
}
