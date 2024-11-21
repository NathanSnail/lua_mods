---@type mod_calllbacks
local M = {}

_G["example.no_brain"] = function(body)
	local brain = {}
	brain.rotation = 5 -- be a spinny
	return brain
end

_G["example.explosion_resist"] = function(body, x, y)
	give_mutation(body, MUT_EXPLOSIVE_RESISTANCE)
	return { nil, nil, x, y } -- this determines spawn extra info
end

function M.post(api, config)
	local spawn_rate = config.spawn_rates or 0.2
	local old_creature_list = creature_list
	creature_list = function(...)
		local r = { old_creature_list(...) }

		register_creature(
			api.acquire_id("example.blob"),
			"data/scripts/lua_mods/mods/example/bodies/blob.bod",
			"example.no_brain"
		)
		register_creature(
			api.acquire_id("example.small"),
			"data/scripts/lua_mods/mods/example/bodies/small.bod",
			"example.no_brain",
			"example.explosion_resist"
		)
		return unpack(r)
	end

	local old_init_biomes = init_biomes
	init_biomes = function(...)
		local r = { old_init_biomes(...) }
		add_creature_spawn_chance("STRT", api.acquire_id("example.blob"), spawn_rate, 1)
		add_creature_spawn_chance("STRT", api.acquire_id("example.small"), spawn_rate, 1)
		return unpack(r)
	end
end
return M
