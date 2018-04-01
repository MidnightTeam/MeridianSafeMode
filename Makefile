THEOS := $(shell source ~/.profile; bash -l -c "echo $$THEOS")
ARCHS  = arm64 armv7 armv7s
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MeridianSafeMode
MeridianSafeMode_FILES = MeridianSafeMode.x
MeridianSafeMode_USE_SUBSTRATE=0

include $(THEOS_MAKE_PATH)/tweak.mk
