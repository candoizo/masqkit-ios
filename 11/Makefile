ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MASQ11
$(TWEAK_NAME)_FILES = 11.xm
$(TWEAK_NAME)_FRAMEWORKS = CoreGraphics
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
