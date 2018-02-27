include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MASQSoundcloud
MASQSoundcloud_FILES = Soundcloud.xm
MASQSoundcloud_INSTALL_PATH = /Library/TweakInject #/Library/Application Support/MASQ/Plugins
MASQSoundcloud_FRAMEWORKS = UIKit CoreGraphics
MASQSoundcloud_CFLAGS = -w -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SoundCloud"
