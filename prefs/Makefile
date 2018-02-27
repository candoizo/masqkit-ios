include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = MASQPrefs
MASQPrefs_FILES = $(wildcard *.m)
MASQPrefs_INSTALL_PATH = /Library/PreferenceBundles
MASQPrefs_FRAMEWORKS = UIKit CoreGraphics AudioToolbox
MASQPrefs_PRIVATE_FRAMEWORKS = Preferences Social
MASQPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/MASQPrefs.plist$(ECHO_END)
