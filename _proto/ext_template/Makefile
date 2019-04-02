ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MASQ11
MASQ11_FILES = 11.xm
MASQ11_FRAMEWORKS = CoreGraphics
MASQ11_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
