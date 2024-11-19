for k, v in ipairs(LUA_MODLOADER_MOD_LIST) do
	if type(v) == "string" then
		local callbacks = dofile("data/scripts/lua_mods/mods/" .. v .. "/post.lua")
		LUA_MODLOADER_MOD_LIST[k] = { v, callbacks }
	end
end
