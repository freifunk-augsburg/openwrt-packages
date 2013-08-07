--[[
LuCI - Lua Configuration Interface

Copyright 2011 Manuel Munz <freifunk at somakoma de>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0
]]--

module "luci.controller.freifunk.tinc-ffa"

function index()
	entry({"admin", "freifunk", "tinc"}, cbi("freifunk/tinc-ffa"),
		_("Augsburg Tinc"), 60)
        entry(
                {"admin", "freifunk", "tinc", "host"},
                cbi("freifunk/tinc-ffa-host")
        ).leaf = true
end
