#
# Copyright (C) 2009 soma <freifunk somakoma de>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=webif-goss
PKG_VERSION:=0.0.1
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/webif-goss
  SECTION:=admin
  CATEGORY:=Administration
  TITLE:=GOSS-Good old shell script webinterface, frontend only
  VERSION:=$(PKG_VERSION)-$(PKG_RELEASE)
  DEPENDS:=
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/webif-goss/description
  This is the public part of the well known Freifunk Firmware ported to Kamikaze.
  This interface is meant for people who can configure their Router from the commandline
  and want to save a good amount of space, that the LUCI-webif would occupy. So one could also
  say that this is a Freifunk webinterface for sysadmins.
endef

define Package/webif-goss/install
	mkdir -p $(1)/www
	$(CP) -r ./files/www/* $(1)/www
	mkdir -p $(1)/etc/
	$(CP) ./files/etc/httpd.conf $(1)/etc/httpd.conf
endef

$(eval $(call BuildPackage,webif-goss))

