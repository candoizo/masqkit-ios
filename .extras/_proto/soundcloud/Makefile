include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MASQSoundCloud
MASQSoundCloud_FILES = SoundCloud.xm
MASQSoundCloud_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SoundCloud"
