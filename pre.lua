dofile("data/scripts/lua_mods/mod_list.lua")
local api = dofile("data/scripts/lua_mods/api.lua")

for _, v in ipairs(LUA_MODLOADER_MOD_LIST) do
	if type(v) == "string" then
		local callbacks = dofile("data/scripts/lua_mods/mods/" .. v .. "/init.lua")
		table.insert(LUA_MODLOADER_LOADED_MODS, { name = v, callbacks = callbacks, config = {} })
	elseif type(v) == "table" then
		LUA_MODLOADER_CONFIG = v[2]
		local callbacks = dofile("data/scripts/lua_mods/mods/" .. v[1] .. "/init.lua")
		LUA_MODLOADER_CONFIG = nil
		table.insert(LUA_MODLOADER_LOADED_MODS, { name = v[1], callbacks = callbacks, config = v[2] })
	else
		table.insert(LUA_MODLOADER_ERRORS, "ERROR: invalid mod list")
	end
end

for _, v in ipairs(LUA_MODLOADER_LOADED_MODS) do
	if (v.callbacks.api_version or 0) > LUA_MODLOADER_VERSION then
		table.insert(
			LUA_MODLOADER_ERRORS,
			"Mod '" .. v.name .. v.callbacks.version and ("' - " .. v.callbacks.version)
				or "' "
					.. "requires a newer version of the modloader, modloader version is v"
					.. LUA_MODLOADER_VERSION
					.. " mod requires v"
					.. v.callbacks.version
		)
	end
end

for _, v in ipairs(LUA_MODLOADER_LOADED_MODS) do
	if v.callbacks.pre then
		v.callbacks.pre(api, v.config)
	end
end
