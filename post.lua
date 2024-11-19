for _, v in ipairs(LUA_MODLOADER_MOD_LIST) do
	dofile("data/scripts/lua_mods/mods/" .. v .. "/post.lua")
end
