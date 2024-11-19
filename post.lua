local api = dofile("data/scripts/lua_mods/api.lua")

for _, v in ipairs(LUA_MODLOADER_MOD_LIST) do
	if v[2].post ~= nil then
		v[2].post(api)
	end
end
