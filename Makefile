include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += src #contains prefs
SUBPROJECTS += 11
SUBPROJECTS += music
SUBPROJECTS += spotify
#SUBPROJECTS += 10
#SUBPROJECTS += soundcloud
#SUBPROJECTS += maize
#SUBPROJECTS += haystack

include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"
