%ctor {
	if (!%c(MASQHousekeeper)) dlopen("/Library/MobileSubstrate/DynamicLibraries/MASQKit.dylib", RTLD_NOW);
}

// %hook PSRootController
// -(id)navigationController:(id)arg1 willShowViewController:(id)arg2 animated:(BOOL)arg3
// {
// 	return %orig;
// }
// %end


// #import "MASQSubPageController.h"
// #import "dlfcn.h"
// id const kGADAdSizeSmartBannerPortrait = nil;
//
// @interface GADMobileAds : NSObject
// +(void)configureWithApplicationID:(id)arg1;
// @end
//
// @interface GADBannerView : UIView
// -(id)initWithAdSize:(id)arg1;
// -(void)setAdUnitID:(id)arg1;
// -(void)setRootViewController:(id)arg1;
// -(void)loadRequest:(id)arg1;
// @end
//
// @interface GADRequest : NSObject
// +(id)request;
// @end
//
// // %ctor {
// //   	dlopen("/Library/PreferenceBundles/MASQPrefs.bundle/MASQPrefs", RTLD_NOW);
// // }
//
// %hook MASQSubPageController
// %new
// -(void)addTips {
//   [%c(GADMobileAds) configureWithApplicationID:@"ca-app-pub-3940256099942544~1458002511"];
//   GADBannerView *bannerView = [[%c(GADBannerView) alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
//   [bannerView setBackgroundColor:UIColor.redColor];
//   bannerView.center = self.view.center;
//   [self.view addSubview:bannerView];
//   [bannerView setAdUnitID:@"ca-app-pub-3940256099942544/2934735716"];
//   [bannerView setRootViewController:self];
//   [bannerView loadRequest:[%c(GADRequest) request]];
// }
// %end
