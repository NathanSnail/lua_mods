local api = dofile("data/scripts/lua_mods/api.lua")

local old_creature_list = creature_list -- printing is only available in these later callbacks
function creature_list(...)
	print("\nActive mods:\n")
	for _, v in ipairs(LUA_MODLOADER_LOADED_MODS) do
		print(v.name .. (v.callbacks.version and (" - " .. v.callbacks.version) or "") .. "\n")
	end
	if #LUA_MODLOADER_ERRORS ~= 0 then
		game_print("Errors occured when loading mods")
		print("\n\nERRORS LOADING MODS:\n\n")
		for _, v in ipairs(LUA_MODLOADER_ERRORS) do
			print(v .. "\n")
		end
		print("\nYOU NEED TO FIX THESE\n\n")
	end
	return old_creature_list(...)
end
for _, v in ipairs(LUA_MODLOADER_LOADED_MODS) do
	if v.callbacks.post ~= nil then
		v.callbacks.post(api, v.config)
	end
end
