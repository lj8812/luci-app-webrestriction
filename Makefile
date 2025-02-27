include $(TOPDIR)/rules.mk

LUCI_TITLE:=网页访问限制
LUCI_DEPENDS:=+luci-compat +luci-base +iptables
LUCI_PKGARCH:=all

PKG_NAME:=luci-app-webrestriction
PKG_VERSION:=1.1
PKG_RELEASE:=1

include $(TOPDIR)/feeds/luci/luci.mk

define Package/luci-app-webrestriction/postinst
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
    /etc/init.d/firewall reload >/dev/null 2>&1
    exit 0
}
endef
