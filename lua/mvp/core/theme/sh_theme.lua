--- @module mvp.themes
mvp.themes = mvp.themes or {}
mvp.themes.cache = mvp.themes.cache or {}

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
    local theme = {}
    setmetatable(theme, {__index = mvp.meta.theme})
    return theme
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

    -- if mvp.themes.cache[themeName] then
    --     mvp.utils.Error('Theme ' .. themeName .. ' already exists!')
    --     return
    -- end

    mvp.themes.cache[themeName] = theme
end

--- Gets a theme by name.
-- @realm shared
-- @tparam string themeName The name of the theme.
-- @treturn Theme The theme.
function mvp.themes.Get(themeName)
    return mvp.themes.cache[themeName]
end

function mvp.themes.GetActive()
    return mvp.themes.cache['MVP Default Dark Theme']
end

function mvp.themes.GetColor(colorName)
    local theme = mvp.themes.GetActive()
    return theme:GetColor(colorName)
end

function mvp.Color(colorName)
    return mvp.themes.GetColor(colorName)
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