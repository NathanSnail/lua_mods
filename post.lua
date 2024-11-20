local api = dofile("data/scripts/lua_mods/api.lua")

for _, v in ipairs(LUA_MODLOADER_LOADED_MODS) do
	if v.callbacks.post ~= nil then
		v.callbacks.post(api, v.config)
	end
end
