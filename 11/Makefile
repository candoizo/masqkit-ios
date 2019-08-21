# TARGET = iphone:clang:11
ARCHS = arm64 #arm64e needed for xs but no linux tc yet?

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MASQ11
$(TWEAK_NAME)_FILES = 11.xm Bg.xm
$(TWEAK_NAME)_FRAMEWORKS = CoreGraphics
$(TWEAK_NAME)_EXTRA_LIBRARIES = MASQKit
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
