include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MASQSpotify
MASQSpotify_FILES = Spotify.xm
MASQSpotify_INSTALL_PATH = /Library/TweakInject
MASQSpotify_FRAMEWORKS = UIKit CoreGraphics
MASQSpotify_CFLAGS = -w -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Spotify"
