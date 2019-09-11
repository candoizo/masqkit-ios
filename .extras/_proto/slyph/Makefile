ARCHS = arm64 #arm64e
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MASQSylph
$(TWEAK_NAME)_FILES = Sylph.xm
$(TWEAK_NAME)_FRAMEWORKS = CoreGraphics
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
