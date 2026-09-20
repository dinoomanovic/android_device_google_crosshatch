#
# Copyright (C) 2018-2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Audio
# Preserve the device's audio features after the primary HAL's Soong migration.
$(call soong_config_set,qtiaudio,feature_24bits_camcorder,true)
$(call soong_config_set,qtiaudio,feature_a2dp_offload,true)
$(call soong_config_set,qtiaudio,feature_cirrus_spkr_protection,true)
$(call soong_config_set,qtiaudio,feature_flicker_sensor_input,true)
$(call soong_config_set,qtiaudio,feature_hwdep_cal,true)
$(call soong_config_set,qtiaudio,feature_maxx_audio,true)
$(call soong_config_set,qtiaudio,feature_multi_voice_sessions,true)
$(call soong_config_set,qtiaudio,feature_snd_monitor,true)
$(call soong_config_set,qtiaudio,feature_sound_trigger,true)
$(call soong_config_set,qtiaudio,feature_usb_tunnel,true)

# Kernel
BOARD_KERNEL_IMAGE_NAME := Image.lz4
TARGET_COMPILE_WITH_MSM_KERNEL := true
TARGET_KERNEL_CLANG_VERSION := r416183b
TARGET_KERNEL_CLANG_PATH := $(abspath .)/prebuilts/clang/kernel/$(HOST_PREBUILT_TAG)/clang-$(TARGET_KERNEL_CLANG_VERSION)
TARGET_KERNEL_CONFIG := b1c1_defconfig
TARGET_KERNEL_LLVM_BINUTILS := false
TARGET_KERNEL_SOURCE := kernel/google/msm-4.9
TARGET_NEEDS_DTBOIMAGE := true


# Partitions
AB_OTA_PARTITIONS += \
    vendor
ifneq ($(PRODUCT_USE_DYNAMIC_PARTITIONS), true)
    BOARD_VENDORIMAGE_PARTITION_SIZE := 805306368
endif
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

# Reserve space for gapps install
-include vendor/lineage/config/BoardConfigReservedSize.mk
ifneq ($(WITH_GMS),true)
BOARD_PRODUCTIMAGE_PARTITION_RESERVED_SIZE := 1069547520
endif

# SELinux
BOARD_SEPOLICY_DIRS += device/google/crosshatch/sepolicy-lineage/dynamic
BOARD_SEPOLICY_DIRS += device/google/crosshatch/sepolicy-lineage/vendor

# Verified Boot
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
