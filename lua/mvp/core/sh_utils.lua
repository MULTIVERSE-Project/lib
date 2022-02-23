mvp = mvp or {}
mvp.utils = mvp.utils or {}

-- Global colors
COLOR_WHITE = Color(255, 255, 255)
COLOR_BLACK = Color(0, 0, 0)
COLOR_RED = Color(255, 0, 0)
COLOR_YELLOW = Color(255, 255, 0)
COLOR_GREEN = Color(0, 255, 0)
COLOR_BLUE = Color(0, 0, 255)

function mvp.utils.Include(fileName, realm, silent)
    local loadingModule = istable(MODULE) and true or false

    if not fileName then
        Error('No file specified to include!')

        return
    end

    realm = realm or ''

    if ((realm:lower() == 'server' or (fileName:find('sv_') ~= nil)) and SERVER) then
        local result = include(fileName)

        if not silent then
            MsgC(Color(32, 118, 248), '[MVP] ', Color(45, 112, 255), '[SV] ', color_white, Format('File "%s" loaded.\n', fileName))
        end

        return result
    elseif (realm:lower() == 'shared' or (fileName:find('sh_') ~= nil) or (fileName:find('shared.lua') ~= nil)) then
        if SERVER then
            AddCSLuaFile(fileName)
        end

        local result = include(fileName)

        if not silent then
            MsgC(Color(32, 118, 248), '[MVP] ', Color(241, 92, 255), '[SH] ', color_white, Format('File "%s" loaded.\n', fileName))
        end

        return result
    elseif (realm:lower() == 'client' or (fileName:find('cl_') ~= nil)) then
        if SERVER then
            AddCSLuaFile(fileName)
        else
            local result = include(fileName)

            if not silent then
                MsgC(Color(32, 118, 248), '[MVP] ', Color(255, 198, 92), '[CL] ', color_white, Format('File "%s" loaded.\n', fileName))
            end

            return result
        end
    end
end

function mvp.utils.IncludeFolder(dir, fromLua, recursive, ignore, realm)
    local rel = 'mvp/'

    local files, folders = file.Find((fromLua and '' or rel) .. dir .. '/*', 'LUA')
    for k, v in pairs(files) do
        if ignore and ignore[v] then continue end
        mvp.utils.Include((fromLua and '' or rel) .. dir .. '/' .. v, realm, false)
    end

    if recursive then
        for k, v in pairs(folders) do
            if ignore and ignore[v] then continue end
            mvp.utils.IncludeFolder((fromLua and '' or rel) .. dir .. '/' .. v, true, true, ignore, realm)
        end
    end
end

function mvp.utils.IsColor(color)
    return istable(color) and (isnumber(color.r) and isnumber(color.g) and isnumber(color.b) and isnumber(color.a or 255))
end

function mvp.utils.LerpColor(frac, from, to)
    if not mvp.utils.IsColor(from) or not mvp.utils.IsColor(to) then
        Error('Not color pased in LerpColor function!')
        return 
    end
    return Color(
		Lerp(frac, from.r, to.r),
		Lerp(frac, from.g, to.g),
		Lerp(frac, from.b, to.b),
		Lerp(frac, from.a, to.a)
	)
end

function mvp.utils.Capital(text)
    local output = text:sub(1, 1):upper() .. text:sub(2)

    return output
end

function mvp.utils.CapitalSentence(text)
    text = string.Explode(' ', text)
    local output = {}

    for k, v in pairs(text) do
        output[#output + 1] = mvp.utils.Capital(v)
    end

    return table.concat(output, ' ')
end

function mvp.utils.Encode(str)
    str = string.gsub(str, "\r?\n", "\r\n")
    str = string.gsub(str, "([^%w%-%.%_%~ ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    str = string.gsub(str, " ", "+")

    return str
end

function mvp.utils.EncodeTable(tableToEncode)
    local argts = {}
    local i = 1

    for k, v in pairs(tableToEncode) do
        argts[i] = mvp.utils.Encode(k) .. "=" .. mvp.utils.Encode(v)
        i = i + 1
    end

    return table.concat(argts, '&')
end

function mvp.utils.EncodeURL(url, args)
    return url .. '?' .. mvp.utils.EncodeTable(args)
end

function mvp.utils.Print(...)
    local args = {...}
    
    MsgC(unpack(args))
    Msg('\n') 
end

local function charWrap(text, remainingWidth, maxWidth)
    local totalWidth = 0

    text = text:gsub('.', function(char)
        totalWidth = totalWidth + surface.GetTextSize(char)

        -- Wrap around when the max width is reached
        if totalWidth >= remainingWidth then
            -- totalWidth needs to include the character width because it's inserted in a new line
            totalWidth = surface.GetTextSize(char)
            remainingWidth = maxWidth
            return '\n' .. char
        end

        return char
    end)

    return text, totalWidth
end

function mvp.utils.TextWrap(text, font, maxWidth)
    local totalWidth = 0

    surface.SetFont(font)

    local spaceWidth = surface.GetTextSize(' ')
    text = text:gsub("(%s?[%S]+)", function(word)
            local char = string.sub(word, 1, 1)
            if char == "\n" or char == "\t" then
                totalWidth = 0
            end

            local wordlen = surface.GetTextSize(word)
            totalWidth = totalWidth + wordlen

            -- Wrap around when the max width is reached
            if wordlen >= maxWidth then -- Split the word if the word is too big
                local splitWord, splitPoint = charWrap(word, maxWidth - (totalWidth - wordlen), maxWidth)
                totalWidth = splitPoint
                return splitWord
            elseif totalWidth < maxWidth then
                return word
            end

            -- Split before the word
            if char == ' ' then
                totalWidth = wordlen - spaceWidth
                return '\n' .. string.sub(word, 2)
            end

            totalWidth = wordlen
            return '\n' .. word
        end)

    return text
end

function mvp.utils.StripRealmPrefix(name)
	local prefix = name:sub(1, 3)

	return (prefix == "sh_" or prefix == "sv_" or prefix == "cl_") and name:sub(4) or name
end

function mvp.utils.UUID(lenght)
    local template = string.rep('x', lenght, '')

    math.randomseed(SysTime())
    
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end