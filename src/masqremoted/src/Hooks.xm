static BOOL changed;

#define kPrefsAppID CFSTR("ca.ndoizo.masqremoted")
#define kSettingsChangedNotification CFSTR("ca.ndoizo.masqremoted.changed")
#define kWantUpdateKey CFSTR("needsUpdate")

static void loadPreferences() {
  CFPreferencesAppSynchronize(kPrefsAppID);
  changed = !CFPreferencesCopyAppValue(kWantUpdateKey, kPrefsAppID) ? NO : [CFBridgingRelease(CFPreferencesCopyAppValue(kWantUpdateKey, kPrefsAppID)) boolValue];
}

static void prefsCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  loadPreferences();
}

%hook MRDNowPlayingServer
-(void)sendArtworkChangedNotification:(id)arg1 forPlayerPath:(id)arg2 {
  %orig;
  CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), kWantUpdateKey, NULL, NULL, true);
}
%end

%ctor {
	@autoreleasepool {
		loadPreferences();

		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
			NULL,
			(CFNotificationCallback)prefsCallback,
			kSettingsChangedNotification,
			NULL,
			CFNotificationSuspensionBehaviorDeliverImmediately
		);
	}
}

// %hook MRDTransactionServer
// -(void)transaction:(id)arg1 didReceivePackets:(id)arg2 receivedSize:(id)arg3 requestedSize:(id)arg4 queue:(id)arg5 completion:(id)arg6 {
//   %orig;
//
// }
// %end
