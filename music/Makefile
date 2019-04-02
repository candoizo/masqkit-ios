ARCHS = arm64
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MASQMusic
$(TWEAK_NAME)_FILES = Music.xm
$(TWEAK_NAME)_FRAMEWORKS = CoreGraphics
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Music Preferences"
