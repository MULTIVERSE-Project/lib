--- A bunch of utility functions for the rest of the codebase
-- @module mvp.utils

mvp.type = mvp.type or {
	[2] = 'string',
	[4] = 'text',
	[8] = 'number',
	[16] = 'player',
	[32] = 'steamid',
	[64] = 'bool',
	[1024] = 'color',
	[2048] = 'vector',

	string = 2,
	text = 4,
	number = 8,
	player = 16,
	steamid = 32,
	bool = 64,
	color = 1024,
	vector = 2048,

	optional = 256,
	array = 512
}

--- Checks if given string is a valid steamid32
-- @realm shared
-- @tparam string value String to check
-- @treturn boolean True if string is a valid steamid, false otherwise
function mvp.utils.IsSteamID(value)
	return string.match(value, '^STEAM_[0-1]:[0-1]:[0-9]*$')
end

--- Checks if given string is a valid steamid64
-- @realm shared
-- @tparam string value String to check
-- @treturn boolean True if string is a valid steamid, false otherwise
function mvp.utils.IsSteamID64(value)
	return string.match(value, '^[0-9]*$')
end

--- Santizes an input value with given type.
-- @realm shared
-- @mvptype type Type to sanitize with.
-- @tparam any input Value to sanitize.
-- @treturn any Sanitized value.
function mvp.utils.SanitazeType(type, input)
	if type == mvp.type.string then
		return tostring(input)
	end
	if type == mvp.type.text then
		return tostring(input)
	end
	if type == mvp.type.number then
		return tonumber(input)
	end
	if type == mvp.type.bool then
		return tobool(input)
	end
	if type == mvp.type.color then
		return istable(input) and Color(input.r or 255, input.g or 255, input.b or 255, input.a or 255) or color_white
	end
	if type == mvp.type.vector then
		return isvector(input) and input or vector_origin
	end
	if type == mvp.type.array then
		return istable(input) and input or {}
	end

	error('Attemped to sanitaze ' .. ( mvp.type[type] and ('invalid type' .. mvp.type[type] ) or ('unknown type' .. type) ))
end

do
	local typeMap = {
		['string'] = mvp.type.string,
		['number'] = mvp.type.number,
		['boolean'] = mvp.type.bool,
		['Player'] = mvp.type.player,
		['Vector'] = mvp.type.vector,
	}

	local tableMap = {
		[mvp.type.color] = function(value)
			return mvp.utils.IsColor(value)
		end,
		[mvp.type.steamid] = function(value)
			return mvp.utils.IsSteamID(value) or mvp.utils.IsSteamID64(value)
		end,
	}

	--- Return `mvp.type` of given value
	-- @realm shared
	-- @tparam any value Value to get type of.
	-- @treturn mvp.type Type of value.
	-- @see mvp.type
	-- @usage print(mvp.utils.GetTypeFromValue('Hello'))
	-- > 2 -- value of mvp.type.string
	--
	-- print(mvp.utils.GetTypeFromValue(123))
	-- > 8 -- value of mvp.type.number
	function mvp.utils.GetTypeFromValue(value)
		local result = typeMap[type(value)]

		if result then
			return result
		end

		if istable(value) then
			for type, check in pairs(tableMap) do
				if check(value) then
					return type
				end
			end
		end
	end
end

function mvp.utils.UUID(lenght)
    local template = string.rep('x', lenght, '')

    math.randomseed(SysTime())
    
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end