--[[
LuCI - Lua Configuration Interface

Copyright 2013 Manuel Munz <freifunk at somakoma dot de>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

]]--

local fs = require "nixio.fs"
local utl = require "luci.util"

m = Map("tinc", "Tinc Hosts Konfiguration", "Hier werden einzelne Tinc-Hosts konfiguriert, damit mit diesen eine Verbindung aufgebaut werden kann.")
m.redirect = luci.dispatcher.build_url("admin/freifunk/tinc")


if not arg[1] or m.uci:get("tinc", arg[1]) ~= "tinc-host" then
	luci.http.redirect(m.redirect)
	return
end

m.uci:set("tinc", arg[1], "net", "ffa")	


i = m:section(NamedSection, arg[1], "tinc-host", "Peer")
i.anonymous = true
i.addremove = false

enabled = i:option(Flag, "enabled", translate("Enable"),
	"Diesen Peer aktivieren.")
enabled.rmempty = false

address = i:option(Value, "Address", "Adresse",
	"Übers Internet erreichbare IP-Addresse oder DNS-Hostname.")
--address.datatype = [[ or("hostname", "ip4addr", "ip6addr") ]]

connectto = i:option(Flag, "connectto", "Ausgehende Verbindung",
	"Verbindung zu diesem Knoten aufbauen.")
connectto.rmempty = false
function connectto.cfgvalue()
	local list = m.uci:get_list("tinc", "ffa", "ConnectTo") or {}
	if utl.contains(list, arg[1]) then
		return "1"
	else
		return "0"
	end
end

function connectto.write(self, section, value)
	local list = m.uci:get_list("tinc", "ffa", "ConnectTo") or {}
	if value == "1" then
		if not utl.contains(list, arg[1]) then
			utl.append(list, arg[1])
			m.uci:set_list("tinc", "ffa", "ConnectTo" , list)
		end
	else
		if utl.contains(list, arg[1]) then
		newlist = {}
			for k,v in ipairs(list) do
				if v ~= arg[1] then
					utl.append(newlist, v)
					m.uci:set_list("tinc", "ffa", "ConnectTo", newlist)
				end
			end
		end
	end
end

port = i:option(Value, "Port", "Port")
port.rmrmpty = true
port.required = true
port.datatype = "range(0,65535)"


local pubkey = "/etc/tinc/ffa/hosts/" .. arg[1]


local key= i:option(TextValue, "Pubkey", "Öffentlicher Schlüssel", "Der öffentliche Schlüssel dieses Knotens. Dieser wird dir in der Regel vom Betreiber dieses Knotens zugeschickt und kann per Copy&Paste hier eingefügt werden.")
key.rows = 10
function key.cfgvalue()
	return fs.readfile(pubkey) or ""
end

function key.write(self, section, value)
	if value and value ~= "" then
		fs.writefile(pubkey, value:gsub("\r\n", "\n"))
	else
		fs.unlink(pubkey)
	end
end

return m
