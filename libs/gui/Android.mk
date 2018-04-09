LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES:= \
	IGraphicBufferConsumer.cpp \
	IConsumerListener.cpp \
	BitTube.cpp \
	BufferItemConsumer.cpp \
	BufferQueue.cpp \
	ConsumerBase.cpp \
	CpuConsumer.cpp \
	DisplayEventReceiver.cpp \
	GLConsumer.cpp \
	GraphicBufferAlloc.cpp \
	GuiConfig.cpp \
	IDisplayEventConnection.cpp \
	IGraphicBufferAlloc.cpp \
	IGraphicBufferProducer.cpp \
	ISensorEventConnection.cpp \
	ISensorServer.cpp \
	ISurfaceComposer.cpp \
	ISurfaceComposerClient.cpp \
	LayerState.cpp \
	Sensor.cpp \
	SensorEventQueue.cpp \
	SensorManager.cpp \
	Surface.cpp \
	SurfaceControl.cpp \
	SurfaceComposerClient.cpp \
	SyncFeatures.cpp \

LOCAL_SHARED_LIBRARIES := \
	libbinder \
	libcutils \
	libEGL \
	libGLESv2 \
	libsync \
	libui \
	libutils \
	liblog

ifeq ($(TARGET_BOARD_PLATFORM), mt6589)
MTK_PATH = ../../../../mediatek/frameworks-ext/native/libs/gui

LOCAL_SRC_FILES += \
	$(MTK_PATH)/BufferQueue.cpp \
	$(MTK_PATH)/FpsCounter.cpp

    LOCAL_CFLAGS := -DLOG_TAG=\"GLConsumer\"
	LOCAL_CFLAGS += -DUSE_DP
	LOCAL_SHARED_LIBRARIES += libdpframework libhardware
	LOCAL_STATIC_LIBRARIES += libgralloc_extra
	LOCAL_SRC_FILES += $(MTK_PATH)/BufferQueueDump.cpp
	LOCAL_C_INCLUDES += \
		$(TOP)/mediatek/hardware/dpframework/inc \
		$(TOP)/mediatek/hardware/gralloc_extra/include
endif

# Executed only on QCOM BSPs
ifeq ($(TARGET_USES_QCOM_BSP),true)
ifneq ($(TARGET_QCOM_DISPLAY_VARIANT),)
    PLATFORM := .
else
    PLATFORM := $(TARGET_BOARD_PLATFORM)
endif
    LOCAL_C_INCLUDES += $(call project-path-for,qcom-display)/$(PLATFORM)/libgralloc
    LOCAL_C_INCLUDES += $(call project-path-for,qcom-display)/$(PLATFORM)/libqdutils
    LOCAL_CFLAGS += -DQCOM_BSP
endif

ifeq ($(BOARD_EGL_SKIP_FIRST_DEQUEUE),true)
    LOCAL_CFLAGS += -DSURFACE_SKIP_FIRST_DEQUEUE
endif

ifeq ($(BOARD_USE_MHEAP_SCREENSHOT),true)
    LOCAL_CFLAGS += -DUSE_MHEAP_SCREENSHOT
endif

LOCAL_MODULE:= libgui

ifeq ($(TARGET_BOARD_PLATFORM), tegra)
	LOCAL_CFLAGS += -DDONT_USE_FENCE_SYNC
endif
ifeq ($(TARGET_BOARD_PLATFORM), tegra3)
	LOCAL_CFLAGS += -DDONT_USE_FENCE_SYNC
endif
ifeq ($(TARGET_TOROPLUS_RADIO), true)
	LOCAL_CFLAGS += -DTOROPLUS_RADIO
endif

include $(BUILD_SHARED_LIBRARY)

ifeq (,$(ONE_SHOT_MAKEFILE))
include $(call first-makefiles-under,$(LOCAL_PATH))
endif
