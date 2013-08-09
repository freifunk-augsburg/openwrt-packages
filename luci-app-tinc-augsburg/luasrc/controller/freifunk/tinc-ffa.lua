--[[ LuCI - Lua Configuration Interface

Copyright 2011 Manuel Munz <freifunk at somakoma de>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0
]]--


module("luci.controller.freifunk.tinc-ffa", package.seeall)

local utl = require "luci.util"

function index()
	entry({"admin", "freifunk", "tinc"}, cbi("freifunk/tinc-ffa"),
		_("Augsburg Tinc"), 60)
        entry(
                {"admin", "freifunk", "tinc", "host"},
                cbi("freifunk/tinc-ffa-host")
        ).leaf = true

	local page  = node("admin", "freifunk", "tinc", "status")
        page.target = call("action_status")
        page.title  = _("Status")
        page.subindex = true
        page.order  = 5
end

function action_status()
	tmpl = require "luci.template"
	local data = getData()
	tmpl.render("tinc-ffa/status", {hosts=data.hosts, status=data.status})
end


function getData()
	local uci = luci.model.uci.cursor_state()

        local hosts = {}
        hosts['status'] = {}
        hosts['hosts'] = {}

	local pid = utl.exec('/usr/sbin/tinc -n ffa pid')
	if pid  and pid ~= "" then
		hosts['status']['up'] = "1"
	else
		hosts['status']['up'] = "0"
	end

	uci:foreach("tinc", "tinc-host", function(s)
                if s.net == 'ffa' then
			hosts['hosts'][s[".name"]] = {
					ip = '?',
					port ='?',
					uptime = '?',
					protocol = '?'
			}
		end
        end)	
        for host,_ in pairs(hosts['hosts']) do
		myname = uci:get("tinc", "ffa", "Name")
                local hostdata = utl.split(utl.exec('/usr/sbin/tinc -n ffa info ' .. host), "\n")
                hosts['hosts'][host]['reachable'] = "0"
                hosts['hosts'][host]['validkey'] = "0"
                hosts['hosts'][host]['udp_confirmed'] = "0"

                for k,v in ipairs(hostdata) do

                        if string.sub(v, 1, 6) == "Online" then
                                local uptime = v:match("[%w%s]*%s*:%s*([%w%s:-]+)") or '?'
                                hosts['hosts'][host]['uptime'] = uptime
                        elseif string.sub(v, 1, 7) == "Address" then
                                local ip = v:match("[%w]:%s*([%w%d+.]+)") or '?'
				local port = v:match(".*port%s(%d+)") or '?'
                                hosts['hosts'][host]['ip'] = ip
                                hosts['hosts'][host]['port'] = port
                        elseif string.sub(v, 1, 6) == "Status" then
				if host == myname then
					hosts['hosts'][host]['reachable'] = "-"
					hosts['hosts'][host]['validkey'] = "-"
                                        hosts['hosts'][host]['udp_confirmed'] = "-"
				else
	                                if string.find(v, "reachable") then
        	                                hosts['hosts'][host]['reachable'] = "1"
                	                end
	                                if string.find(v, "validkey") then
	                                        hosts['hosts'][host]['validkey'] = "1"
	                                end
	                                if string.find(v, "udp_confirmed") then
	                                        hosts['hosts'][host]['udp_confirmed'] = "1"
        	                        end
				end
                        elseif string.sub(v, 1, 8) == "Protocol" then
                                local proto = v:match("%w*:%s*([%d.]*)")
                                hosts['hosts'][host]['protocol'] = proto or '?'

                        end
                end
        end

	return hosts
end
