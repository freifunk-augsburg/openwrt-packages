include $(TOPDIR)/rules.mk

PKG_NAME:=openvpn-ipredator-setup
PKG_VERSION:=0.0.2
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/openvpn-ipredator-setup
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=VPN
  DEPENDS:=+openvpn +olsrd-mod-dyn-gw-plain
  TITLE:=Configuration for using ipredator openvpn with Meshkit firmware
  URL:=http://trac.augsburg.freifunk.net
endef

define Package/openvpn-ipredator-setup/description
  This will setup almost everything to use ipredator VPN with meshkit firmware.
  All you need to do after installation is to add your credentials to
  /etc/openvpn/ipredator/IPredator.auth.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/openvpn-ipredator-setup/install
	$(CP) ./files/* $(1)/
endef

define Package/openvpn-ipredator-setup/postinst
        [ -n "$${IPKG_INSTROOT}" ] || {
		( . /etc/uci-defaults/openvpn-ipredator-setup ) && rm -f /etc/uci-defaults/openvpn-ipredator-setup
        	exit 0
        }
endef


$(eval $(call BuildPackage,openvpn-ipredator-setup))
