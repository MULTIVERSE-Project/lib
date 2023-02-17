--- @module mvp.themes
mvp.themes = mvp.themes or {}
mvp.themes.list = mvp.themes.list or {}

mvp.themes.path = 'mvp/themes/'

--- Creates a new theme.
-- @realm shared
-- @treturn Theme The new theme.
-- @see Theme
-- @usage
-- local theme = mvp.themes.New()
-- theme:SetName('My Theme')
-- theme:SetAuthor('Myself')
-- theme:SetDescription('My theme with pink'n'white colors.')
-- theme:SetColors({...})
--
-- mvp.themes.Register(theme)

function mvp.themes.New()
    local theme = {colors = {}}
    
    return setmetatable(theme, {__index = mvp.meta.theme})
end

--- Registers new theme.
-- @realm shared
-- @tparam Theme theme The theme to register.
function mvp.themes.Register(theme)
    local themeName = theme:GetName()
    
    if not themeName then
        mvp.utils.Error('Theme must have a name!')
        return 
    end

    -- if mvp.themes.list[themeName] then
    --     mvp.utils.Error('Theme ' .. themeName .. ' already exists!')
    --     return
    -- end

    mvp.themes.list[themeName] = theme
end

--- Gets a theme by name.
-- @realm shared
-- @tparam string themeName The name of the theme.
-- @treturn Theme The theme.
function mvp.themes.Get(themeName)
    return mvp.themes.list[themeName]
end

--- Gets active theme.
-- @realm shared
-- @treturn Theme The active theme.
function mvp.themes.GetActive()
    return mvp.themes.list[mvp.config.Get('theme', 'MVP Default Dark Theme')]
end

--- Gets color of the active theme.
-- @realm shared
-- @tparam string colorName The name of the color.
-- @treturn Color The color.
function mvp.themes.GetColor(colorName)
    local theme = mvp.themes.GetActive()
    
    return theme:GetColor(colorName)
end

--- Loads all themes from `mvp.themes.path` variable.
-- @realm shared
-- @internal
function mvp.themes.Load()
    local themeFiles = file.Find(mvp.themes.path .. '*', 'LUA')

    for _, themeFile in pairs(themeFiles) do
        mvp.loader.LoadSHFile(mvp.themes.path .. themeFile)
    end
end