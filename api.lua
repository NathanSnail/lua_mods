---@type table<string, string>
local id_map = {}
local counter = 0
---@type mod_api
local api = {
	acquire_id = function(key)
		local earlier = id_map[key]
		if earlier then
			return earlier
		end
		local s = ""
		while counter ~= 0 do
			s = s .. string.char(bit.band(counter, 0xFF))
			counter = bit.rshift(counter, 8)
		end
		while s:len() < 4 do
			s = s .. "\n" -- lua_modloader reserves the newline character for its id padding
			-- we also use left to right generation so it probably won't conflict with the actual modloader
		end
		return s
	end,
}
return api
