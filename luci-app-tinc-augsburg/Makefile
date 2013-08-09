include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-tinc-augsburg
PKG_VERSION:=0.0.2
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-tinc-augsburg
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  DEPENDS:=+tinc-11-nolzo
  TITLE:=Preconfigures Tinc to connect to the Freifunk Augsburg Mesh
  URL:=http://trac.augsburg.freifunk.net
endef

define Package/luci-app-tinc-augsburg/description
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

define Package/luci-app-tinc-augsburg/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/freifunk
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/freifunk
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/tinc-ffa
	$(CP) ./files/* $(1)/
	$(CP) ./luasrc/controller/freifunk/* $(1)/usr/lib/lua/luci/controller/freifunk/
	$(CP) ./luasrc/model/cbi/freifunk/* $(1)/usr/lib/lua/luci/model/cbi/freifunk/
	$(CP) ./luasrc/view/tinc-ffa/* $(1)/usr/lib/lua/luci/view/tinc-ffa/
endef

define Package/luci-app-tinc-augsburg/postinst
        [ -n "$${IPKG_INSTROOT}" ] || {
        ( . /etc/uci-defaults/tinc-setup-augsburg ) && rm -f /etc/uci-defaults/tinc-setup-augsburg
            exit 0
        }
endef


$(eval $(call BuildPackage,luci-app-tinc-augsburg))
