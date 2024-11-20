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
		print("ERROR: invalid mod list\n")
	end
end

for _, v in ipairs(LUA_MODLOADER_LOADED_MODS) do
	if v.callbacks.pre then
		v.callbacks.pre(api, v.config)
	end
end
