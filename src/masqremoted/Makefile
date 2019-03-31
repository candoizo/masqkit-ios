include $(THEOS)/makefiles/common.mk
SOURCE=src
TWEAK_NAME = masqremoted
$(TWEAK_NAME)_FILES = $(wildcard $(SOURCE)/*.xm) $(wildcard $(SOURCE)/*.m)
$(TWEAK_NAME)_FRAMEWORKS = CoreFoundation Foundation
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 mediaremoted"

# SUBPROJECTS += sdks
# include $(THEOS_MAKE_PATH)/aggregate.mk
