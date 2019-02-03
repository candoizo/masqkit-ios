include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MASQMusic
MASQMusic_FILES = Music.xm
MASQMusic_FRAMEWORKS = CoreGraphics
MASQMusic_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Music"
