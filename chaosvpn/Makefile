#
# Copyright (C) 2010-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=chaosvpn
PKG_VERSION:=2.12
PKG_RELEASE:=2

PKG_SOURCE:=${PKG_NAME}-${PKG_VERSION}.tar.gz
PKG_SOURCE_URL:=http://www.music-piracy.com/
PKG_MD5SUM:=f6f03d61eaaab5e88001d71982e542f8
include $(INCLUDE_DIR)/package.mk

define Package/chaosvpn
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Config generator for chaos vpn
  SUBMENU:=VPN
  DEPENDS:=+ip +tinc +kmod-tun +libopenssl
  URL:=https://wiki.hamburg.ccc.de/index.php/ChaosVPN::DebianHowto
  MAINTAINER:=Christopher J. Pilkington <cjp@0x1.net>
endef

define Package/chaosvpn/description
	Configure tincd for the chaosvpn network
endef

MAKE_FLAGS += \
	COPT="$(TARGET_CFLAGS) $(TARGET_CPPFLAGS) $(TARGET_LDFLAGS)"

define Package/chaosvpn/install
	$(INSTALL_DIR) $(1)/etc/tinc/chaos/ $(1)/usr/sbin/ $(1)/etc/init.d/ $(1)/etc/hotplug.d/iface/ $(1)/etc/config/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/chaosvpn $(1)/usr/sbin/
	$(INSTALL_DATA) ./files/chaosvpn.config $(1)/etc/config/chaosvpn
	sed -e 's/"\/sbin\/ip /"\/usr\/sbin\/ip /' <$(PKG_BUILD_DIR)/chaosvpn.conf >$(1)/etc/tinc/chaosvpn.conf
	$(INSTALL_BIN) ./files/chaosvpn_config.sh $(1)/usr/sbin/
	$(INSTALL_BIN) ./files/chaosvpn.init $(1)/etc/init.d/chaosvpn
	$(INSTALL_BIN) ./files/chaosvpn.hotplug $(1)/etc/hotplug.d/iface/40-chaosvpn
endef

$(eval $(call BuildPackage,chaosvpn))

