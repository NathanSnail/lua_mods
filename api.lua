---@type loaded_mod[]
LUA_MODLOADER_LOADED_MODS = LUA_MODLOADER_LOADED_MODS or {}
---@type string[]
LUA_MODLOADER_ERRORS = {}
LUA_MODLOADER_VERSION = LUA_MODLOADER_VERSION or 1
---If you need to access the config in the callback generator this will do it, but its also passed to the hooks.
---@type table?
LUA_MODLOADER_CONFIG = LUA_MODLOADER_CONFIG or nil

---@type table<string, string>
local id_map = {}
local counter = 0
-- stylua: ignore start
local charset = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "-", ")", "(", "*", "&", "^", "%", "$", "#", "@", "!", "[", "]"}
-- stylua: ignore end
local log_file = io.open("lua_log.txt", "w")
if log_file == nil then
	error("Lua modloader couldn't start, log file wasn't able to be opened")
end

local function generate(val)
	local s = ""
	while val ~= 0 do
		local low = val % #charset
		s = s .. charset[1 + low]
		val = math.floor(val / #charset)
	end
	while s:len() < 4 do
		s = "=" .. s
	end
	return s
end
local api
---@type mod_api
api = {
	log = function(...)
		for _, v in ipairs({ ... }) do
			local srep = tostring(v)
			log_file:write(srep)
		end
		log_file:flush()
	end,
	acquire_id = function(key)
		local earlier = id_map[key]
		if earlier then
			---@diagnostic disable-next-line: return-type-mismatch
			return earlier
		end
		local s = generate(counter)
		api.log("id for " .. key .. " is " .. s .. " with index " .. counter .. "\n")
		id_map[key] = s
		counter = counter + 1
		---@diagnostic disable-next-line: return-type-mismatch
		return s
	end,
}
return api
