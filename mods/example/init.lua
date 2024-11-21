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

-- pre hook is for changing how functions that everyone uses behaves
function M.pre(api, config)
	-- shadow the add_creature_spawn_chance function so we can modify it
	local old_add_creature_spawn_chance = add_creature_spawn_chance
	function add_creature_spawn_chance(...)
		local args = { ... } -- collect the arguments into a table for easy modification
		args[4] = args[4] * 20 -- this arg is the xp drop amount, so make everything drop 20x xp
		return old_add_creature_spawn_chance(unpack(args)) -- call the original with the modified args
	end
end

-- post hook is for defining creatures
function M.post(api, config)
	local spawn_rate = config.spawn_rates or 0.2
	-- we shadow the creature_list function to call our additional code after it
	local old_creature_list = creature_list
	creature_list = function(...)
		-- call the original
		local r = { old_creature_list(...) }

		-- register our creatures
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
		-- return the result of the original, not strictly neccesary here but useful in some situations
		return unpack(r)
	end

	-- shadow init_biomes function to call our stuff afterwards
	local old_init_biomes = init_biomes
	init_biomes = function(...)
		local r = { old_init_biomes(...) }
		-- add our creatures to the starting biome, if spawn_rates are too high you will start to see issues where only some creatures can spawn
		-- to fix this make sure the sum isn't too high, i will perhaps add a prehook for compat with this in future
		add_creature_spawn_chance("STRT", api.acquire_id("example.blob"), spawn_rate, 1)
		add_creature_spawn_chance("STRT", api.acquire_id("example.small"), spawn_rate, 1)
		return unpack(r)
	end
end

return M
