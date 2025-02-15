local dofile_once_cache = {}

---@param filename string
---@return any ...
function dofile_once(filename)
	local cached = dofile_once_cache[filename]
	if cached then
		return unpack(cached)
	end
	local result = { dofile(filename) }
	dofile_once_cache[filename] = result
	return unpack(result)
end

---Sometimes you just need a crash for testing
---@diagnostic disable-next-line: lowercase-global
function crash()
	require("ffi").cast("int *", 0)[0] = 0
end

dofile_once("data/scripts/lua_mods/key_codes.lua")
dofile_once("data/scripts/lua_mods/mod_list.lua")
local api = dofile_once("data/scripts/lua_mods/api.lua")

for _, v in ipairs(LUA_MODLOADER_MOD_LIST) do
	if type(v) == "string" then
		local success, callbacks = pcall(dofile_once, "data/scripts/lua_mods/mods/" .. v .. "/init.lua")
		if not success then
			table.insert(LUA_MODLOADER_ERRORS, "Error loading mod: " .. v .. " got the error " .. callbacks)
		end
		table.insert(LUA_MODLOADER_LOADED_MODS, { name = v, callbacks = callbacks, config = {} })
	elseif type(v) == "table" then
		LUA_MODLOADER_CONFIG = v[2]
		local name = v[1]
		local success, callbacks = pcall(dofile_once, "data/scripts/lua_mods/mods/" .. name .. "/init.lua")
		if not success then
			table.insert(LUA_MODLOADER_ERRORS, "Error loading mod: " .. name .. " got the error " .. callbacks)
		end
		LUA_MODLOADER_CONFIG = nil
		table.insert(LUA_MODLOADER_LOADED_MODS, { name = name, callbacks = callbacks, config = v[2] })
	else
		table.insert(
			LUA_MODLOADER_ERRORS,
			"ERROR: invalid mod list, " .. tostring(v) .. ": " .. type(v) .. " is not a valid mod"
		)
	end
end

api.log("Active mods:\n")
for _, v in ipairs(LUA_MODLOADER_LOADED_MODS) do
	api.log(v.name .. (v.callbacks.version and (" - " .. v.callbacks.version) or "") .. "\n")
end
for _, v in ipairs(LUA_MODLOADER_LOADED_MODS) do
	if (v.callbacks.api_version or 0) > LUA_MODLOADER_VERSION then
		table.insert(
			LUA_MODLOADER_ERRORS,
			"Mod '" .. v.name .. v.callbacks.version and ("' - " .. v.callbacks.version)
				or "' "
					.. "requires a newer version of the modloader, modloader version is v"
					.. LUA_MODLOADER_VERSION
					.. " mod requires v"
					.. v.callbacks.version
		)
	end
end

for _, v in ipairs(LUA_MODLOADER_LOADED_MODS) do
	if v.callbacks.pre then
		local success, err = pcall(v.callbacks.pre, api, v.config)
		if not success then
			table.insert(LUA_MODLOADER_ERRORS, "Error running prehook for mod " .. v.name .. " got an error: " .. err)
		end
	end
end
