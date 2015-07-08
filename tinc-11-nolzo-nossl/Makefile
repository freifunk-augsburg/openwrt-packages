#
# Copyright (C) 2007-2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=tinc
PKG_VERSION:=1.1pre11
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://www.tinc-vpn.org/packages
PKG_MD5SUM:=e9cc2971927d31e703f0c2b1791a4edf

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/tinc-11-nolzo-nossl
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+kmod-tun
  TITLE:=VPN tunneling daemon 1.1pre11 (without ssl and lzo)
  URL:=http://www.tinc-vpn.org/
  SUBMENU:=VPN
endef

define Package/tinc-11-nolzo-nossl/description
  tinc is a Virtual Private Network (VPN) daemon that uses tunnelling and
  encryption to create a secure private network between hosts on the Internet.
endef

TARGET_CFLAGS += -std=gnu99

CONFIGURE_ARGS += \
	--disable-zlib \
	--disable-lzo \
	--disable-curses \
	--disable-readline \
	--disable-legacy-protocol

define Package/tinc-11-nolzo-nossl/install
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

define Package/tinc-11-nolzo-nossl/conffiles
/etc/config/tinc
endef

$(eval $(call BuildPackage,tinc-11-nolzo-nossl))
