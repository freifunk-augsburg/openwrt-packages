#
# Copyright (C) 2009-2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=quagga-dn42
PKG_VERSION:=1.1.0-dn42.12
PKG_RELEASE:=1

PKG_SOURCE:=quagga-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=http://www.diac24.net/files/quagga/
PKG_MD5SUM:=53f5efddae280e5e62760a3a3197285b

PKG_BUILD_DIR:=$(BUILD_DIR)/quagga-$(PKG_VERSION)

PKG_CONFIG_DEPENDS:= \
	CONFIG_PACKAGE_quagga-dn42-isisd \
	CONFIG_PACKAGE_quagga-dn42-ripngd

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/quagga-dn42/Default
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=quagga-dn42
  TITLE:=The Quagga Software Routing Suite (with DN42-patches)
  URL:=http://www.quagga.net
  MAINTAINER:=soma <freifunk at somakoma dot de>
endef

define Package/quagga-dn42
  $(call Package/quagga-dn42/Default)
  DEPENDS:= +librt
  MENU:=1
endef

define Package/quagga-dn42/description
  A routing software package that provides TCP/IP based routing services
  with routing protocols support such as RIPv1, RIPv2, RIPng, OSPFv2,
  OSPFv3, BGP-4, and BGP-4+
endef

define Package/quagga-dn42-libzebra
  $(call Package/quagga-dn42/Default)
  TITLE:=zebra library
endef

define Package/quagga-dn42-libospf
  $(call Package/quagga-dn42/Default)
  TITLE:=OSPF library
endef

define Package/quagga-dn42-bgpd
  $(call Package/quagga-dn42/Default)
  DEPENDS+= +quagga-dn42-libzebra
  TITLE:=BGPv4, BGPv4+, BGPv4- routing engine
endef

define Package/quagga-dn42-isisd
  $(call Package/quagga-dn42/Default)
  TITLE:=IS-IS routing engine
endef

define Package/quagga-dn42-ospfd
  $(call Package/quagga-dn42/Default)
  DEPENDS+= +quagga-dn42-libospf +quagga-dn42-libzebra
  TITLE:=OSPFv2 routing engine
endef

define Package/quagga-dn42-ospf6d
  $(call Package/quagga-dn42/Default)
  DEPENDS+= +quagga-dn42-libospf +quagga-dn42-libzebra @IPV6
  TITLE:=OSPFv3 routing engine
endef

define Package/quagga-dn42-ripd
  $(call Package/quagga-dn42/Default)
  DEPENDS+= +quagga-dn42-libzebra
  TITLE:=RIP routing engine
endef

define Package/quagga-dn42-ripngd
  $(call Package/quagga-dn42/Default)
  DEPENDS+= +quagga-dn42-libzebra @BROKEN
  TITLE:=RIPNG routing engine
endef

define Package/quagga-dn42-vtysh
  $(call Package/quagga-dn42/Default)
  DEPENDS+= quagga-dn42-libzebra +libreadline +libncurses
  TITLE:=integrated shell for Quagga routing software
endef

define Package/quagga-dn42/conffiles
/etc/quagga/zebra.conf
endef

define Package/quagga-dn42-bgpd/conffiles
/etc/quagga/bgpd.conf
endef

define Package/quagga-dn42-isisd/conffiles
/etc/quagga/isisd.conf
endef

define Package/quagga-dn42-ospfd/conffiles
/etc/quagga/ospfd.conf
endef

define Package/quagga-dn42-ospf6d/conffiles
/etc/quagga/ospf6d.conf
endef

define Package/quagga-dn42-ripd/conffiles
/etc/quagga/ripd.conf
endef

define Package/quagga-dn42-ripngd/conffiles
/etc/quagga/ripngd.conf
endef

CONFIGURE_ARGS+= \
	--localstatedir=/var/run/quagga \
	--sysconfdir=/etc/quagga/ \
	--enable-shared \
	--disable-static \
	--enable-vtysh \
	--enable-user=quagga \
	--enable-group=quagga \
	--enable-pie=no \
	--enable-multipath=8 \

ifneq ($(CONFIG_PACKAGE_quagga-dn42-isisd),)
  CONFIGURE_ARGS+= --enable-isisd
endif

ifneq ($(CONFIG_PACKAGE_quagga-dn42-ripngd),)
  CONFIGURE_ARGS+= --enable-ripngd
endif

define Package/quagga-dn42/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/zebra $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/watchquagga $(1)/usr/sbin/
	# avoid /etc being set to 0750
	$(INSTALL_DIR) $(1)/etc/quagga
	chmod 0750 $(1)/etc/quagga
	$(INSTALL_CONF) ./files/quagga.conf $(1)/etc/quagga/zebra.conf
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/quagga $(1)/usr/sbin/quagga.init
	$(INSTALL_BIN) ./files/quagga.init $(1)/etc/init.d/quagga
endef

define Package/quagga-dn42/postinst
#!/bin/sh

name=quagga
id=51

# do not change below
# check if we are on real system
if [ -z "$${IPKG_INSTROOT}" ]; then
	# create copies of passwd and group, if we use squashfs
	rootfs=`mount |awk '/root/ { print $$5 }'`
	if [ "$$rootfs" = "squashfs" ]; then
		if [ -h /etc/group ]; then
			rm /etc/group
			cp /rom/etc/group /etc/group
		fi
		if [ -h /etc/passwd ]; then
			rm /etc/passwd
			cp /rom/etc/passwd /etc/passwd
		fi
	fi
fi

echo ""
if [ -z "$$(grep ^\\$${name}: $${IPKG_INSTROOT}/etc/group)" ]; then
	echo "adding group $$name to /etc/group"
	echo "$${name}:x:$${id}:" >> $${IPKG_INSTROOT}/etc/group
fi

if [ -z "$$(grep ^\\$${name}: $${IPKG_INSTROOT}/etc/passwd)" ]; then
	echo "adding user $$name to /etc/passwd"
	echo "$${name}:x:$${id}:$${id}:$${name}:/tmp/.$${name}:/bin/false" >> $${IPKG_INSTROOT}/etc/passwd
fi

grep -q '^zebra[[:space:]]*2601/tcp' $${IPKG_INSTROOT}/etc/services 2>/dev/null
if [ $$? -ne 0 ]; then
echo "zebrasrv      2600/tcp" >>$${IPKG_INSTROOT}/etc/services
echo "zebra         2601/tcp" >>$${IPKG_INSTROOT}/etc/services
echo "ripd          2602/tcp" >>$${IPKG_INSTROOT}/etc/services
echo "ripngd        2603/tcp" >>$${IPKG_INSTROOT}/etc/services
echo "ospfd         2604/tcp" >>$${IPKG_INSTROOT}/etc/services
echo "bgpd          2605/tcp" >>$${IPKG_INSTROOT}/etc/services
echo "ospf6d        2606/tcp" >>$${IPKG_INSTROOT}/etc/services
echo "ospfapi       2607/tcp" >>$${IPKG_INSTROOT}/etc/services
echo "isisd         2608/tcp" >>$${IPKG_INSTROOT}/etc/services
fi
endef

define Package/quagga-dn42-bgpd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/bgpd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/quagga
	chmod 0750 $(1)/etc/quagga
	$(INSTALL_CONF) ./files/quagga.conf $(1)/etc/quagga/bgpd.conf
endef

define Package/quagga-dn42-isisd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/isisd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/quagga
	chmod 0750 $(1)/etc/quagga
	$(INSTALL_CONF) ./files/quagga.conf $(1)/etc/quagga/isisd.conf
endef

define Package/quagga-dn42-ospfd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/ospfd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/quagga
	chmod 0750 $(1)/etc/quagga
	$(INSTALL_CONF) ./files/quagga.conf $(1)/etc/quagga/ospfd.conf
endef

define Package/quagga-dn42-ospf6d/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/ospf6d $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/quagga
	chmod 0750 $(1)/etc/quagga
	$(INSTALL_CONF) ./files/quagga.conf $(1)/etc/quagga/ospf6d.conf
endef

define Package/quagga-dn42-ripd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/ripd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/quagga
	chmod 0750 $(1)/etc/quagga
	$(INSTALL_CONF) ./files/quagga.conf $(1)/etc/quagga/ripd.conf
endef

define Package/quagga-dn42-ripngd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/ripngd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/quagga
	chmod 0750 $(1)/etc/quagga
	$(INSTALL_CONF) ./files/quagga.conf $(1)/etc/quagga/ripngd.conf
endef

define Package/quagga-dn42-vtysh/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/vtysh $(1)/usr/bin/
endef

define Package/quagga-dn42-libospf/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libospf.so.* $(1)/usr/lib/
endef

define Package/quagga-dn42-libzebra/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libzebra.so.* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,quagga-dn42))
$(eval $(call BuildPackage,quagga-dn42-libzebra))
$(eval $(call BuildPackage,quagga-dn42-libospf))
$(eval $(call BuildPackage,quagga-dn42-bgpd))
$(eval $(call BuildPackage,quagga-dn42-isisd))
$(eval $(call BuildPackage,quagga-dn42-ospfd))
$(eval $(call BuildPackage,quagga-dn42-ospf6d))
$(eval $(call BuildPackage,quagga-dn42-ripd))
$(eval $(call BuildPackage,quagga-dn42-ripngd))
$(eval $(call BuildPackage,quagga-dn42-vtysh))
