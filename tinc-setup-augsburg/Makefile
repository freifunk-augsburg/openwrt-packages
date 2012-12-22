include $(TOPDIR)/rules.mk

PKG_NAME:=tinc-setup-augsburg
PKG_VERSION:=0.0.1
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/tinc-setup-augsburg
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=VPN
  DEPENDS:=+tinc-nolzo
  TITLE:=Preconfigures Tinc to connect to the Freifunk Augsburg Mesh
  URL:=http://trac.augsburg.freifunk.net
endef

define Package/tinc-setup-augsburg/description
  Preconfigures Tinc to connect to the Freifunk Augsburg Mesh. The user still needs to exchange
  pubkeys with his neigbors, give the tinc instance a name and the interface tinc interface 'ffa'
  an ip address.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/tinc-setup-augsburg/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,tinc-setup-augsburg))
