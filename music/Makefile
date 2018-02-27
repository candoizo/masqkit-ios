include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MASQMusic
MASQMusic_INSTALL_PATH = /Library/TweakInject #/Library/Application Support/MASQ/Plugins
MASQMusic_FILES = Music.xm
MASQMusic_FRAMEWORKS = UIKit
MASQMusic_CFLAGS = -w -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Music"
