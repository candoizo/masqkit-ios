#import "MASQSocialExtendedController.h"
#import "../src/MASQHousekeeper.h"

@implementation MASQSocialExtendedController
+(id)composeViewControllerForServiceType:(id)arg1 {
    MASQSocialExtendedController * c = [super composeViewControllerForServiceType:arg1];
    if (c.view) {
      c.platterView = [c topPlatter];
      c.showPoint = CGPointMake(c.platterView.center.x, c.platterView.center.y);
      c.platterView.center = CGPointMake(c.platterView.center.x, c.platterView.center.y-150);
    	c.gonePoint = CGPointMake(c.platterView.center.x, c.platterView.center.y);
      [((UIWindow *)[UIApplication.sharedApplication valueForKey:@"_statusBarWindow"]) insertSubview:c.platterView atIndex:0];
      [c setInitialText:[c tweetText]];
      c.view.tintColor = [NSClassFromString(@"MASQHousekeeper") masqTintWithAlpha:1];
      c.remoteViewController.view.tintColor = [NSClassFromString(@"MASQHousekeeper") masqTintWithAlpha:1];
    }
    return c;
}

-(void)showPlatter {
  [UIView animateWithDuration:0.25 animations:^{
       self.platterView.center = self.showPoint;
     } completion:nil];
}

- (void)viewWillDisappear:(BOOL)arg1 {
  [super viewWillDisappear:arg1];
  if (arg1) [self dismissPlatter];
}

-(void)dismissPlatter {
    [UIView animateWithDuration:0.2
     animations:^{self.platterView.center = self.gonePoint;}
     completion:^(BOOL finished){ [self.platterView removeFromSuperview]; }];
}

-(NSString *)tweetText {
  return @"Im loving MASQKit by @candoizo! 🎭 join the party, free at https://candoizo.gitlab.io/masq";
}

-(id)topPlatter {
  UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/1.015, self.view.bounds.size.height/5)];
  v.backgroundColor = UIColor.whiteColor;
  v.clipsToBounds = YES;
  [v _setContinuousCornerRadius:9];
  v.center = CGPointMake(self.view.center.x, 40);

  UIView * blurb = [self blurbLabel];
  blurb.center = CGPointMake(self.view.center.x, v.bounds.size.height*0.45);
  [v addSubview:blurb];

  UIView * donate = [self buttonViewWithTitle:@"☕ Coffee" selector:@selector(donateAction) iconBundle:@"com.apple.mobileme.fmf1"];
  UIView * twitter = [self buttonViewWithTitle:@"🐦 Twitter" selector:@selector(profileAction) iconBundle:@"com.atebits.Tweetie2"];
  UIView * support = [self buttonViewWithTitle:@"📬 Support" selector:@selector(supportAction) iconBundle:@"com.apple.mobilemail"];
  twitter.center = CGPointMake(v.bounds.size.width*0.2, v.bounds.size.height * 0.7);
  donate.center = CGPointMake(v.bounds.size.width*0.5, v.bounds.size.height * 0.7);
  support.center = CGPointMake(v.bounds.size.width*0.8, v.bounds.size.height * 0.7);

  [v addSubview:donate];
  [v addSubview:twitter];
  [v addSubview:support];
  return v;
}

-(id)blurbLabel {
  UILabel *tweakTitle = [[UILabel alloc] init];
  tweakTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
  tweakTitle.text = @"🎭 Love This Tweak? Let me know! -candoizo";
  tweakTitle.textAlignment = 1;
  tweakTitle.textColor = [UIColor.blackColor colorWithAlphaComponent:0.85];
  tweakTitle.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
  [tweakTitle sizeToFit];
  return tweakTitle;
}

-(UIButton *)buttonWithSelector:(SEL)arg1 iconBundle:(NSString *)arg2 {
  float btnSize = self.view.bounds.size.width/9;
  UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnSize, btnSize)];
  UIImage * icon = [UIImage _applicationIconImageForBundleIdentifier:arg2 format:1 scale:UIScreen.mainScreen.scale];
  [b setImage:icon forState:UIControlStateNormal];
  [b addTarget:self action:arg1 forControlEvents:UIControlEventTouchUpInside];

  return b;
}

-(id)buttonViewWithTitle:(NSString *)arg1 selector:(SEL)arg2 iconBundle:(NSString *)arg3 {
  UIButton * b = [self buttonWithSelector:arg2 iconBundle:arg3];

  UILabel *label = [[UILabel alloc] init];
  label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:9];
  label.text = arg1;
  label.textAlignment = 1;
  label.textColor = [UIColor.blackColor colorWithAlphaComponent:0.95];
  label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
  [label sizeToFit];
  label.center = CGPointMake(b.center.x, b.bounds.size.height * 1.15);
  [b addSubview:label];
  return b;
}

-(void)profileAction {
	NSString *user = @"candoizo";
	if([UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
	[UIApplication.sharedApplication openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];
	else if([UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:@"twitter:"]])
	[UIApplication.sharedApplication openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];
	else [UIApplication.sharedApplication openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];
}

-(void)supportAction {
  NSString *url = @"https://cydia.saurik.com/api/support/org.thebigboss.masq";
  if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia:"]])
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"cydia://url/" stringByAppendingString:url]]];
  else [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(void)donateAction {
  [UIApplication.sharedApplication openURL:[NSURL URLWithString:@"https://www.paypal.me/andreasott"]];
}
@end
