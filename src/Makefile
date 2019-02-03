include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MASQKit
MASQKit_FILES = $(wildcard *.m)
MASQKit_FRAMEWORKS = UIKit CoreGraphics QuartzCore
MASQKit_PRIVATE_FRAMEWORKS = MediaRemote
MASQKit_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += ../prefs
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 Preferences"
