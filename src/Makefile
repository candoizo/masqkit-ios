GO_EASY_ON_ME = 1
DEBUG = 0
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MASQKit
MASQKit_INSTALL_PATH = /Library/TweakInject/
MASQKit_FILES = MASQThemeManager.m MASQArtworkView.m MASQBlurredImageView.m Init.xm
MASQKit_FRAMEWORKS = UIKit CoreGraphics QuartzCore
MASQKit_PRIVATE_FRAMEWORKS = MediaRemote
MASQKit_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
