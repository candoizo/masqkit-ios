TWEAK_NAME = MASQKit

$(TWEAK_NAME)_FILES = $(wildcard *.m)
$(TWEAK_NAME)_FRAMEWORKS = UIKit CoreGraphics QuartzCore
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = MediaRemote
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += ../prefs masqremoted
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 Preferences"
