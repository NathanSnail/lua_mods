local api = dofile_once("data/scripts/lua_mods/api.lua")

for _, v in ipairs(LUA_MODLOADER_LOADED_MODS) do
	if v.callbacks.post ~= nil then
		local success, err = pcall(v.callbacks.post, api, v.config)
		if not success then
			table.insert(LUA_MODLOADER_ERRORS, "Error running prehook for mod " .. v.name .. " got an error: " .. err)
		end
	end
end

local num_errors = #LUA_MODLOADER_ERRORS
if num_errors ~= 0 then
	api.log("\n\n" .. num_errors .. " ERRORS LOADING MODS:\n\n")
	for _, v in ipairs(LUA_MODLOADER_ERRORS) do
		api.log(v .. "\n")
	end
	api.log("\nYOU NEED TO FIX THESE\n\n")

	local old_creature_list = creature_list -- game printing is only available in these later callbacks
	function creature_list(...)
		game_print(num_errors .. " Errors occured when loading mods")
		return old_creature_list(...)
	end
end
