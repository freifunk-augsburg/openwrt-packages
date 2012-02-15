#
# Copyright (C) 
#
# This is free software, licensed under the GPL 2 license.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dpflib
PKG_RELEASE:=1
PKG_VERSION:=0.1alpha
PKG_BUILD_DIR:= $(BUILD_DIR)/$(PKG_NAME)
PKG_BUILD_DEPENDS:=libusb

include $(INCLUDE_DIR)/package.mk


define Package/dpflib
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=static DPF Appotech AX206 driver Library (for lcd4linux)
  MAINTAINER:=irimi@openwrt.org
endef

define Package/dpflib/description
  digital photo frame driver for Appotech AX206 to be linked by lcd4linux.
endef


define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
	$(CP) ./src/dpf.h $(STAGING_DIR)/usr/include
endef

define Build/Configure
endef

TARGET_CFLAGS += \
	-I$(STAGING_DIR)/usr/include \
	-D_GNU_SOURCE

MAKE_FLAGS += \
	FPIC="$(FPIC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS) -L."

define Package/dpflib/install
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/libdpf.a $(STAGING_DIR)/usr/lib/libdpf.a
endef

$(eval $(call BuildPackage,dpflib))
