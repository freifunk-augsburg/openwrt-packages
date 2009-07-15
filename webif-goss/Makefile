#
# Copyright (C) 2009 soma <freifunk somakoma de>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=webif-goss
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/webif-goss
  SECTION:=admin
  CATEGORY:=Administration
  TITLE:=GOSS-Good old shell script webinterface, frontend only
  DEPENDS:=
endef

define Package/webif-goss/description
  This is the public part of the well known Freifunk Firmware ported to Kamikaze.
  This interface is meant for people who can configure their Router from the commandline
  and want to save a good amount of space, that the LUCI-webif would occupy. So one could also
  say that this is a Freifunk webinterface for sysadmins.
endef

define Package/webif-goss/install
	$(INSTALL_DIR) ./files/www
	$(CP) ./files/etc/httpd.conf $(1)/etc/httpd.conf
endef

$(eval $(call BuildPackage,webif-goss))

