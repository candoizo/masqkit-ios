include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MASQHaystack
MASQHaystack_FILES = Haystack.xm
MASQHaystack_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
