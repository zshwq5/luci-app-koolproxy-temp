module("luci.controller.koolproxy",package.seeall)
function index()
if not nixio.fs.access("/etc/config/koolproxy")then
return
end
entry({"admin","services","koolproxy"},cbi("koolproxy/global"),_("koolproxy"),1).dependent=true
end
