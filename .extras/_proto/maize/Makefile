include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MASQMaize
MASQMaize_FILES = Maize.xm
MASQMaize_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
