ifeq ($(FINALPACKAGE), 1)
export ARCHS = arm64 arm64e
export FINALPACKAGE=1
export DEBUG=0
export TARGET= iphone:clang:10.2
else
export ARCHS = arm64
endif

TWEAK_NAME = MASQKit
SUBPROJECTS += prefs

$(TWEAK_NAME)_FILES = $(wildcard *.m)
$(TWEAK_NAME)_FRAMEWORKS = UIKit CoreGraphics QuartzCore
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = MediaRemote
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_USE_SUBSTRATE = 0

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 Preferences SpringBoard"
	# install.exec "killall -9 Preferences"
