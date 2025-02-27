local uci = luci.model.uci.cursor()
local m, s, o

m = Map("webrestriction", translate("网页访问限制"), 
    translate("实时控制设备网络访问，配置立即生效"))

-- 全局设置
s = m:section(NamedSection, "global", "settings", translate("全局设置"))
s.anonymous = true
s.addremove = false

o = s:option(Flag, "enable", translate("启用控制"))
o.rmempty = false

o = s:option(ListValue, "mode", translate("限制模式"))
o:value("whitelist", translate("白名单模式"))
o:value("blacklist", translate("黑名单模式"))
o.default = "blacklist"

-- MAC地址规则
s = m:section(TypedSection, "rule", translate("设备列表"), 
    translate("输入MAC地址（支持自动补全）"))
s.template = "cbi/tblsection"
s.addremove = true
s.anonymous = true

o = s:option(Value, "mac", translate("MAC地址"))
o.datatype = "macaddr"
luci.sys.net.mac_hints(function(mac, name)
    o:value(mac, "%s (%s)" %{mac, name})
end)

o = s:option(Flag, "enable", translate("启用规则"))
o.default = "1"
o.rmempty = false

-- 保存后立即应用规则
function m.on_after_commit(self)
    luci.sys.call("iptables -F FORWARD")
    luci.sys.call("/etc/init.d/firewall reload >/dev/null")
end

return m
