#
# Copyright (C) 2007-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tinc-nocompression
PKG_VERSION:=1.0.16
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://www.tinc-vpn.org/packages \
	http://ftp.yi.se/pub/tinc \
	http://www.mirrors.wiretapped.net/security/network-security/tinc
PKG_MD5SUM:=f1c7ed94878725fb2cf4efb02bf160da

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/tinc-nocompression
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+kmod-tun
  TITLE:=VPN tunneling daemon (without compression)
  URL:=http://www.tinc-vpn.org/
  SUBMENU:=VPN
endef

define Package/tinc-nocompression/description
  tinc is a Virtual Private Network (VPN) daemon that uses tunnelling and
  encryption to create a secure private network between hosts on the Internet.
 Compression is disabled in this version to save space.
endef

TARGET_CFLAGS += -std=gnu99

CONFIGURE_ARGS += \
	--with-kernel="$(LINUX_DIR)" \
	--disable-zlib \
	--disable-lzo

define Package/tinc-nocompression/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/tincd $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,tinc-nocompression))
