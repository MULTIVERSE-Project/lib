--- A bunch of utility functions for the rest of the codebase
-- @module mvp.ui
mvp.ui = mvp.ui or {}

mvp.ui.cachedIconFonts = mvp.ui.cachedIconFonts or {}
mvp.ui.faIcons = mvp.ui.faIcons or {}

http.Fetch('https://raw.githubusercontent.com/MULTIVERSE-Project/lib/data/icons.json', function(body)
    local data = util.JSONToTable(body)
    mvp.ui.faIcons = data

    mvp.ui.Print('Loaded ', Color(68, 189, 50), table.Count(data), color_white, ' icons')
end)

--- Table that represents an icon from [Font Awesome](https://fontawesome.com/search?m=free&s=brands%2Csolid).
-- @table IconData
-- @realm client
-- @tfield string text The icon to display
-- @tfield string font The font to use for the icon
-- @see mvp.ui.GetIcon
-- @see mvp.ui.DrawIcon

local stylesMap = {
    ['solid'] = 'fas',
    ['regular'] = 'far',
    ['brands'] = 'fab'
}

--- Gets [Font Awesome](https://fontawesome.com/search?m=free&s=brands%2Csolid) icon
-- @internal
-- @realm client
-- @tparam string unicode Unicode of the icon from [Font Awesome](https://fontawesome.com/search?m=free&s=brands%2Csolid) site.
-- @tparam[opt=16] number size Size of the icon.
-- @tparam[opt] string style Style of the icon. Function will try to determine style automatically if not specified.
-- @treturn IconData Icon table.
-- @usage
-- local icon = mvp.ui.GetIcon("check", 32)
-- 
-- draw.SimpleText(icon.text, icon.font, 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
function mvp.ui.GetIcon(unicode, size, style)
    size = size or 16

    local iconType = 'fas'

    if mvp.ui.faIcons[unicode] then
        iconType = stylesMap[mvp.ui.faIcons[unicode].styles[1]]
        unicode = mvp.ui.faIcons[unicode].unicode
    else
        for k, v in pairs(mvp.ui.faIcons) do
            if v.unicode ~= unicode then
                continue
            end

            iconType = stylesMap[v.styles[1]]
            unicode = v.unicode
            break 
        end
    end

    local baseFont = ''

    if iconType == 'fa' or iconType == 'fas' then
        baseFont = 'Font Awesome 6 Free Solid'
    elseif iconType == 'far' then
        baseFont = 'Font Awesome 6 Free Regular'
    elseif iconType == 'fab' then
        baseFont = 'Font Awesome 6 Brands Regular'
    end

    local font = mvp.fonts.Get(size, baseFont, 500)
    local iconFont = font .. '_' .. unicode

    if mvp.ui.cachedIconFonts[iconFont] then
        return mvp.ui.cachedIconFonts[iconFont]
    end

    local icon = {
        text = utf8.char(tonumber('0x' .. unicode)),
        font = font
    }

    mvp.ui.cachedIconFonts[iconFont] = icon

    return icon
end

--- Draws [Font Awesome](https://fontawesome.com/search?m=free&s=brands%2Csolid) icon.
-- @realm client
-- @tparam number x X position of the icon.
-- @tparam number y Y position of the icon.
-- @tparam string unicode Unicode of the icon from Font Awesome site.
-- @tparam[opt=16] number size Size of the icon.
-- @tparam[opt=color_white] Color color Color of the icon.
-- @tparam[opt] string style Style of the icon. Function will try to determine style automatically if not specified.
-- @treturn IconData Icon table.
function mvp.ui.DrawIcon(x, y, unicode, size, color, style)
    local icon = mvp.ui.GetIcon(unicode, size, style)
    draw.SimpleText(icon.text, icon.font, x, y, color or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    return icon
end

--- Draws [Font Awesome](https://fontawesome.com/search?m=free&s=brands%2Csolid) icon with alignment control.
-- @realm client
-- @tparam number x X position of the icon.
-- @tparam number y Y position of the icon.
-- @tparam string unicode Unicode of the icon from Font Awesome site.
-- @tparam[opt=16] number size Size of the icon.
-- @tparam[opt=color_white] Color color Color of the icon.
-- @tparam[opt] string style Style of the icon. Function will try to determine style automatically if not specified.
-- @tparam[opt=TEXT_ALIGN_CENTER] number alignX Horizontal alignment of the icon.
-- @tparam[opt=TEXT_ALIGN_CENTER] number alignY Vertical alignment of the icon.
-- @treturn IconData Icon table.
function mvp.ui.DrawIconExt(x, y, unicode, size, color, style, alignX, alignY)
    local icon = mvp.ui.GetIcon(unicode, size, style)
    draw.SimpleText(icon.text, icon.font, x, y, color or color_white, alignX, alignY)

    return icon
end