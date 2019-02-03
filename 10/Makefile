include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MASQ10
MASQ10_FILES = 10.xm
MASQ10_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
