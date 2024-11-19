---@type mod_calllback
local M = {}

_G["example.no_brain"] = function(body)
	local brain = {}
	brain.rotation = 5 -- be a spinny
	return brain
end

function M.post(api)
	local old_creature_list = creature_list
	function creature_list(...)
		local r = { old_creature_list(...) }

		register_creature(
			api.acquire_id("example.blob"),
			"data/scripts/lua_mods/mods/example/bodies/blob.bod",
			"example.no_brain"
		)
		return unpack(r)
	end

	local old_init_biomes = init_biomes
	function init_biomes(...)
		local r = { old_init_biomes(...) }
		add_creature_spawn_chance("STRT", api.acquire_id("example.blob"), 0.5, 1)
		return unpack(r)
	end
end
return M
