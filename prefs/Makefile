include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = MASQSettings
MASQSettings_FILES = $(wildcard *.m) Init.xm
MASQSettings_INSTALL_PATH = /Library/PreferenceBundles
MASQSettings_FRAMEWORKS = UIKit CoreGraphics #\
#StoreKit CoreTelephony AVFoundation AudioToolbox EventKit \
#EventKitUI SystemConfiguration AdSupport MessageUI CoreMedia \
#CoreMotion MediaPlayer MobileCoreServices GLKit CFNetwork \
#CoreVideo QuartzCore OpenGLES Security

MASQSettings_PRIVATE_FRAMEWORKS = Preferences Social
MASQSettings_CFLAGS = -fobjc-arc
#MASQSettings_LDFLAGS += -F$(THEOS)/lib/
#MASQSettings_WEAK_FRAMEWORKS = GoogleMobileAds

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/MASQSettings.plist$(ECHO_END)
