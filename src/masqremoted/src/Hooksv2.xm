%ctor {
  Class hooking = nil;
  if ([NSBundle.mainBundle.bundleIdentifier isEqualToString:@"com.apple.SpringBoard"])
  hooking = objc_getClass("SBMediaController")
  else hooking = objc_getClass("MRNowPlayingPlayerClient")
  %init(Player = hooking)
}

// mrclient only exists on ios 11 +

%hook Player
-(void)setNowPlayingInfo:(id)arg1 {

}
%end
