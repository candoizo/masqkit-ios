ifeq ($(FINALPACKAGE), 1)
export ARCHS = arm64 arm64e
export FINALPACKAGE=1
export DEBUG=0
export TARGET= iphone:clang:11
else
export ARCHS = arm64
endif

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MASQ11
$(TWEAK_NAME)_FILES = 11.xm Bg.xm
$(TWEAK_NAME)_FRAMEWORKS = CoreGraphics
$(TWEAK_NAME)_EXTRA_LIBRARIES = MASQKit
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
