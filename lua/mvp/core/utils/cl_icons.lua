--- A bunch of utility functions for the rest of the codebase
-- @module mvp.utils
mvp.utils = mvp.utils or {}

mvp.utils.cachedIconFonts = mvp.utils.cachedIconFonts or {}
mvp.utils.faIcons = mvp.utils.faIcons or {}

http.Fetch('https://raw.githubusercontent.com/MULTIVERSE-Project/lib/data/icons.json', function(body)
    local data = util.JSONToTable(body)
    mvp.utils.faIcons = data

    mvp.utils.Print('Loaded ', Color(68, 189, 50), table.Count(data), color_white, ' icons')
end)

--- Table that represents an icon from [Font Awesome](https://fontawesome.com/search?m=free&s=brands%2Csolid).
-- @table IconData
-- @realm client
-- @tfield string text The icon to display
-- @tfield string font The font to use for the icon
-- @see mvp.utils.GetIcon
-- @see mvp.utils.DrawIcon

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
-- local icon = mvp.utils.GetIcon("check", 32)
-- 
-- draw.SimpleText(icon.text, icon.font, 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
function mvp.utils.GetIcon(unicode, size, style)
    size = size or 16

    local iconType = 'fas'

    if mvp.utils.faIcons[unicode] then
        iconType = stylesMap[mvp.utils.faIcons[unicode].styles[1]]
        unicode = mvp.utils.faIcons[unicode].unicode
    else
        for k, v in pairs(mvp.utils.faIcons) do
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

    local font = mvp.utils.GetFont(size, baseFont, 500)
    local iconFont = font .. '_' .. unicode

    if mvp.utils.cachedIconFonts[iconFont] then
        return mvp.utils.cachedIconFonts[iconFont]
    end

    local icon = {
        text = utf8.char(tonumber('0x' .. unicode)),
        font = font
    }

    mvp.utils.cachedIconFonts[iconFont] = icon

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
function mvp.utils.DrawIcon(x, y, unicode, size, color, style)
    local icon = mvp.utils.GetIcon(unicode, size, style)
    draw.SimpleText(icon.text, icon.font, x, y, color or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    return icon
end

concommand.Add('mvp_fa_icons', function()
    local frame = vgui.Create('DFrame')
    frame:SetSize(ScrW() * .5, ScrH() * .7)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle('Font Awesome Icons')

    local scroll = vgui.Create('DScrollPanel', frame)
    scroll:Dock(FILL)
    scroll:DockMargin(5, 5, 5, 5)

    local hint = vgui.Create('DLabel', frame)
    hint:SetText('Click on the icon to copy it to clipboard')
    hint:SetFont(mvp.utils.GetFont(24, 'Proxima Nova Regular', 200))
    hint:SetTextColor(color_white)
    hint:Dock(TOP)

    local list = vgui.Create('DIconLayout', scroll)
    list:Dock(FILL)
    list:DockMargin(5, 5, 5, 5)
    list:SetSpaceY(10)
    list:SetSpaceX(10)

    for k, v in pairs(mvp.utils.faIcons) do
        local icon = mvp.utils.GetIcon(v.unicode, 32)
        local iconPanel = list:Add('DButton')
        iconPanel:SetSize(48, 48)
        iconPanel:SetTooltip(k)
        iconPanel:SetMouseInputEnabled(true)
        iconPanel.Paint = function(self, w, h)
            draw.SimpleText(icon.text, icon.font, w * .5, h * .5, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            return true
        end

        iconPanel.DoClick = function()
            SetClipboardText('mvp.utils.GetIcon(\'' .. k .. '\', iconSize)')
        end
    end
end)