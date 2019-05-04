ARCHS = arm64 #arm64
TWEAK_NAME = MASQSpotify
$(TWEAK_NAME)_FILES = Spotify.xm
$(TWEAK_NAME)_FRAMEWORKS = UIKit CoreGraphics
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Spotify Preferences"
