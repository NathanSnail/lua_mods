local ffi = require("ffi")

ffi.cdef([[
typedef unsigned short USHORT;
USHORT GetAsyncKeyState(int vKey);
]])

---The unsafe api represents an extension to the main game api that is usable everywhere, but requires direct memory editing to work.
---@class unsafe_api
local M = {
	---Throws an error if this function is outdated, currently it requires updating with every game version. If this function doesn't error it worked.
	---@param id body_id
	set_player_body_id = function(id)
		local p_body_id = ffi.cast("int *", 0x1401f49a0) -- the player body id global for md5 8bae632057a197aae64f6c1d3a2bfb40
		local old_id = get_player_body_id()
		if p_body_id[0] ~= old_id then
			error("Set player body id has an outdated address")
		end
		p_body_id[0] = id
		if p_body_id[0] ~= get_player_body_id() then
			p_body_id[0] = old_id
			error("Set player body id just corrupted some random memory, attempting to recover")
		end
	end,

	---Returns whether the key is currently pressed, not tied to the framerate.
	---@param code key_code
	---@return boolean
	key_pressed = function(code)
		local state = ffi.C.GetAsyncKeyState(code)
		local pressed = bit.band(state, bit.lshift(1, 15)) ~= 0
		return pressed
	end,
}

return M
