TARGET = iphone:8.0
SOURCE = src
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Analytica
$(TWEAK_NAME)_FILES = $(wildcard $(SOURCE)/*.xm) $(wildcard $(SOURCE)/*.m)
$(TWEAK_NAME)_FRAMEWORKS = UIKit CoreGraphics CoreFoundation Foundation Security Fabric Crashlytics
$(TWEAK_NAME)_LDFLAGS = -lz -undefined dynamic_lookup
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

# SUBPROJECTS += sdks
# include $(THEOS_MAKE_PATH)/aggregate.mk
