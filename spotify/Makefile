include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MASQSpotify
MASQSpotify_FILES = Spotify.xm
$(TWEAK_NAME)_FRAMEWORKS = UIKit CoreGraphics
MASQSpotify_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Spotify"
