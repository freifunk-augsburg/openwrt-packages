#
# Copyright (C) 2007-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tinc
PKG_VERSION:=1.0.16
PKG_RELEASE:=2

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://www.tinc-vpn.org/packages \
	http://ftp.yi.se/pub/tinc \
	http://www.mirrors.wiretapped.net/security/network-security/tinc
PKG_MD5SUM:=f1c7ed94878725fb2cf4efb02bf160da

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/tinc-nolzo
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+kmod-tun +libopenssl
  TITLE:=VPN tunneling daemon (without lzo compression)
  URL:=http://www.tinc-vpn.org/
  SUBMENU:=VPN
endef

define Package/tinc/conffiles
/etc/tinc
endef

define Package/tinc/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	echo "Enabling rc.d symlink for tinc"
	/etc/init.d/tinc enable
fi
exit 0
endef

define Package/tinc/prerm
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	echo "Removing rc.d symlink for tinc"
	/etc/init.d/tinc disable
fi
exit 0
endef

define Package/tinc-nolzo/description
  tinc is a Virtual Private Network (VPN) daemon that uses tunnelling and
  encryption to create a secure private network between hosts on the Internet.
  LZO-Compression is disabled in this version to save space.
endef

TARGET_CFLAGS += -std=gnu99

CONFIGURE_ARGS += \
	--with-kernel="$(LINUX_DIR)" \
	--with-zlib="$(STAGING_DIR)/usr" \
	--disable-lzo

define Package/tinc-nolzo/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/tincd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/tinc.init $(1)/etc/init.d/tinc
	$(INSTALL_DIR) $(1)/etc/tinc
	$(INSTALL_DATA) ./files/etc/tinc/nets.boot $(1)/etc/tinc/nets.boot
endef

$(eval $(call BuildPackage,tinc-nolzo))
