#
# Copyright (C) 2007-2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=tinc
PKG_VERSION:=1.1-git-prepre12
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-de7d9ee437bc0e5d72f8c6744e1df7ea7b64d2e9
PKG_SOURCE:=de7d9ee437bc0e5d72f8c6744e1df7ea7b64d2e9.tar.gz
PKG_SOURCE_URL:=https://github.com/gsliepen/tinc/archive/
PKG_MD5SUM:=43b34dd26b69b1259b37cee72aad5443

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk

define Package/tinc-11/Default
  TITLE:=VPN tunneling daemon 1.1 using $2 (git version de7d9ee437bc0e5d72f8c6744e1df7ea7b64d2e9)
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+kmod-tun $(3)
  URL:=http://www.tinc-vpn.org/
  SUBMENU:=VPN
  VARIANT:=$(1)
endef

Package/tinc-11-openssl=$(call Package/tinc-11/Default,openssl,experimental protocol and openssl,+libopenssl)
Package/tinc-11-nossl=$(call Package/tinc-11/Default,nossl,experimental protocol)

ifeq ($(BUILD_VARIANT),openssl)
CONFIG_TINC11_OPENSSL:=y
endif
ifeq ($(BUILD_VARIANT),nossl)
CONFIG_TINC11_NOSSL:=y
endif


#Package/tinc11-openssl/config=$(call Package/tinc-11/config/Default,openssl)
#Package/tinc11-nossl/config=$(call Package/tinc-11/config/Default,nossl)

define Package/tinc-11/description
  tinc is a Virtual Private Network (VPN) daemon that uses tunnelling and
  encryption to create a secure private network between hosts on the Internet.
endef

TARGET_CFLAGS += -std=gnu99

CONFIGURE_ARGS += \
	--disable-zlib \
	--disable-lzo \
	--disable-curses \
	--disable-readline

ifeq ($(BUILD_VARIANT),openssl)
  CONFIGURE_ARGS += --with-openssl-include=$(STAGING_DIR)/usr/include
  CONFIGURE_ARGS += --with-openssl-lib=$(STAGING_DIR)/usr/lib
else
  CONFIGURE_ARGS += --disable-legacy-protocol
endif

define Package/tinc-11-$(BUILD_VARIANT)/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/tincd $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/tinc $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) files/$(PKG_NAME).init $(1)/etc/init.d/$(PKG_NAME)
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) files/$(PKG_NAME).config $(1)/etc/config/$(PKG_NAME)
	$(INSTALL_DIR) $(1)/etc/tinc
	$(INSTALL_DIR) $(1)/lib/upgrade/keep.d
	$(INSTALL_DATA) files/tinc.upgrade $(1)/lib/upgrade/keep.d/tinc
endef

define Package/tinc-11-$(BUILD_VARIANT)/conffiles
/etc/config/tinc
endef

$(eval $(call BuildPackage,tinc-11-openssl))
$(eval $(call BuildPackage,tinc-11-nossl))
