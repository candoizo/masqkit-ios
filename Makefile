#export ARCHS=arm64
export THEOS_DEVICE_IP=localhost
export THEOS_DEVICE_PORT=2222

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += src
SUBPROJECTS += prefs
#SUBPROJECTS += 10 #working except need a case to hide the control center's artwork when not playing which i have in cc10
SUBPROJECTS += 11
SUBPROJECTS += music #shit
SUBPROJECTS += spotify #working!
#SUBPROJECTS += soundcloud #image problems
#SUBPROJECTS += maize #working perfectly

include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"
