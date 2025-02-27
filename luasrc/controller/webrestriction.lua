module("luci.controller.webrestriction", package.seeall)

function index()
    entry({"admin", "services", "webrestriction"}, cbi("webrestriction"), _("访问限制"), 45).dependent = true
end
