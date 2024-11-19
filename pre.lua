dofile("data/scripts/lua_mods/mod_list.lua")
local api = dofile("data/scripts/lua_mods/api.lua")

for k, v in ipairs(LUA_MODLOADER_MOD_LIST) do
	if type(v) == "string" then
		local callbacks = dofile("data/scripts/lua_mods/mods/" .. v .. "/init.lua")
		LUA_MODLOADER_MOD_LIST[k] = { v, callbacks }
		v = LUA_MODLOADER_MOD_LIST[k]
	end
	if v[2].post then
		v[2].post(api)
	end
end
