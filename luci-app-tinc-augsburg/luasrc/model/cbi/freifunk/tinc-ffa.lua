--[[
LuCI - Lua Configuration Interface

Copyright 2013 Manuel Munz <freifunk at somakoma dot de>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0
]]--

local fs = require "nixio.fs"
local uci = require "luci.model.uci".cursor()
local utl = require "luci.util"

local myname = uci:get("tinc", "ffa", "Name")


m = Map("tinc", "Tinc Wizard für Freifunk Augsburg", "Dieser Wizard hilft dir dabei, Tinc fürs Augsburger Intracityvpn einzurichten." )
m:chain('tinc')

function m.on_parse()
	if not m.uci:get('tinc', 'ffa') then
		m.uci:section("tinc", "tinc-net", "ffa")
	end
	if myname then
		if not m.uci:get('tinc', myname) then
			m.uci:section("tinc", "tinc-host", myname)
			m.uci:set("tinc", myname, "net", "ffa")
			m.uci:set("tinc", myname, "enabled", "1")
		end
	end
end

function m.on_before_commit(self)
	m.uci:commit('network')
end


c = m:section(NamedSection, "ffa", "tinc-net", "")
c.addremove = true

local enabled = c:option(Flag, "enabled", translate("Enabled"))
enabled.default = "1"
enabled.rmempty = false



if myname then
	local name = c:option(DummyValue, "Name", "Name")
else
	local name = c:option(Value, "Name", "Name", "Darf nur alphanumerische Zeichen und Unterstrich enthalten. Kann später nicht mehr geändert werden.")
	name.required = True
	name.rmempty = False
	m.redirect = luci.dispatcher.build_url("admin/freifunk/tinc")
	return m
end


local addr = c:option(Value, "Address", "Adresse", "Extern erreichbare Adresse des Tinc-Knotens. Idealerweise eine (Dyn-)DNS-Adresse. Diese Adresse wird benötigt, wenn andere Tinc-Knoten Verbindungen zu diesem Knoten initiieren sollen.")
function addr.cfgvalue()
	return m.uci:get('tinc', myname, 'Address')
end
function addr.write(self, section, value)
	if value then
		m.uci:set('tinc', myname, 'Address', value)
	end
end
addr.datatype = "or(hostname, ipaddr)"

local port = c:option(Value, "Port", "Port", "Extern erreichbarer Port des Tinc-Knotens. In der Regel verwenden wir hier 4223. Dieser Port wird benötigt, enn andere Tinc-Knoten Verbindungen zu diesem Knoten initiieren sollen.")
function port.cfgvalue()
	return m.uci:get('tinc', myname, 'Port')
end
function port.write(self, section, value)
	if value then
		m.uci:set('tinc', myname, 'Port', value)
	end
end
port.datatype = "range(0,65535)"

local ip = c:option(Value, "ipaddr", "IP-Adresse des Tunnels", "Die interne IP des Tunnels im Mesh. Bitte eine Adresse aus 10.11.63.x verwenden und auf der Webseite registrieren.")
ip.required = True
ip.rmempty = False
function ip.cfgvalue()
	return m.uci:get('network', 'ffa', 'ipaddr')
end
function ip.write(self, section, value)
	if value then
		m.uci:set('network', 'ffa', 'ipaddr', value)
		m.uci:commit('network')
		m:chain('network')
	end
end
ip.datatype = "ip4addr"

local key = c:option(DummyValue, "Pubkey", "Öffentlicher Schlüssel", "Der Public Key dieses Knotens. Dieser muss in allen Knoten mit denen dieser Knoten eine Verbindung haben soll eingerichtet werden. Dazu diesen Schlüssel zum Betreiber des anderen Knotens schicken.")

if myname then
	pubkey = '/etc/tinc/ffa/hosts/' .. myname
	key.rawhtml = true
	key.rows = 10
	function key.cfgvalue()
		if fs.access(pubkey) then
			out = "<pre>"
			local address = m.uci:get('tinc', myname, 'Address')
			if address then
				out = out .. 'Address = ' .. address .. '\n'
			end
			local port = m.uci:get('tinc', myname, 'Port')
			if port then
				out = out .. 'Port = ' .. port .. '\n'
			end

		out = out .. fs.readfile(pubkey)
			out = out .. "</pre>"
			return out
		else
			return "not generated yet"
		end
	end
else
	key.value = "not generated yet"
end	



hosts = m:section(TypedSection, "tinc-host", "Hosts", "Bekannte Knoten mit denen eine Tinc-Verbindung aufgebaut werden kann.")
hosts.addremove = true
hosts.anonymous = false
hosts.extedit   = luci.dispatcher.build_url("admin/freifunk/tinc/host/%s")
hosts.template  = "cbi/tblsection"

function hosts.create(self, sectionname)
	local sid = TypedSection.create(self, sectionname)
	luci.http.redirect(hosts.extedit % sectionname)
end

function hosts.filter(self, sectionname)

	if m.uci:get("tinc", sectionname, "net") and m.uci:get("tinc", sectionname, "net") ~= "ffa" then
		return nil
	else
		if sectionname ~= myname then
			return sectionname
		end
	end

end


local enabled = hosts:option(Flag, "enabled", translate("Enable"))
enabled.rmempty = false

local connectto = hosts:option(DummyValue, "connectto", "Ausgehende Verbindungen")
function connectto.cfgvalue(self,section)
	local list = m.uci:get_list("tinc", "ffa", "ConnectTo") or {}
	if utl.contains(list, section) then
		return "1"
	else
		return "0"
	end
end

local address hosts:option(DummyValue, "Address", "Addresse")

local port = hosts:option(DummyValue, "Port", translate("Port"))





return m

