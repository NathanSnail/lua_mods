---@type loaded_mod[]
LUA_MODLOADER_LOADED_MODS = LUA_MODLOADER_LOADED_MODS or {}
---If you need to access the config in the callback generator this will do it, but its also passed to the hooks.
---@type table?
LUA_MODLOADER_CONFIG = LUA_MODLOADER_CONFIG or nil
---@type table<string, string>
local id_map = {}
local counter = 0
-- stylua: ignore start
local charset = { "A", "R", "i", "z", "B", "S", "j", "0", "C", "T", "k", "1", "D", "U", "l", "2", "E", "V", "m", "3", "F", "W", "n", "4", "G", "X", "o", "5", "H", "Y", "p", "6", "I", "Z", "q", "7", "J", "a", "r", "8", "K", "b", "s", "9", "L", "c", "t", "+", "M", "d", "u", "/", "N", "e", "v", "O", "f", "w", "P", "g", "x", "Q", "h", "y"}
-- stylua: ignore end
local function generate(val)
	local s = ""
	while val ~= 0 do
		local low = val % 64
		s = s .. charset[1 + low]
		val = math.floor(val / 64)
	end
	while s:len() < 4 do
		s = "=" .. s
	end
	return s
end
---@type mod_api
local api = {
	acquire_id = function(key)
		local earlier = id_map[key]
		if earlier then
			---@diagnostic disable-next-line: return-type-mismatch
			return earlier
		end
		local s = generate(counter)
		print(s, counter, "\n")
		id_map[key] = s
		counter = counter + 1
		---@diagnostic disable-next-line: return-type-mismatch
		return s
	end,
}
return api
