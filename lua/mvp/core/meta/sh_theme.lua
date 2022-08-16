--- Theme class
-- @classmod Theme
mvp.meta = mvp.meta or {}
mvp.meta.theme = mvp.meta.theme or {
    colors = {}
}

--- Set's the theme's name.
-- @function SetName
-- @realm shared
-- @tparam string name The theme's name.

--- Gets the theme's name.
-- @function GetName
-- @realm shared
-- @treturn string The theme's name.
AccessorFunc(mvp.meta.theme, 'name', 'Name')

--- Set's the theme's author.
-- @function SetAuthor
-- @realm shared
-- @tparam string author The theme's author.

--- Gets the theme's author.
-- @function GetAuthor
-- @realm shared
-- @treturn string The theme's author.
AccessorFunc(mvp.meta.theme, 'author', 'Author')

--- Set's the theme's description.
-- @function SetDescription
-- @realm shared
-- @tparam string description The theme's description.

--- Gets the theme's description.
-- @function GetDescription
-- @realm shared
-- @treturn string The theme's description.
AccessorFunc(mvp.meta.theme, 'description', 'Description')

--- Set's the theme's version.
-- @function SetVersion
-- @realm shared
-- @tparam string version The theme's version.

--- Gets the theme's version.
-- @function GetVersion
-- @realm shared
-- @treturn string The theme's version.
AccessorFunc(mvp.meta.theme, 'version', 'Version')

--- Set's the theme's url.
-- @function SetURL
-- @realm shared
-- @tparam string url The theme's url.

--- Gets the theme's url.
-- @function GetURL
-- @realm shared
-- @treturn string The theme's url.
AccessorFunc(mvp.meta.theme, 'url', 'URL')

--- Set's color by key from `ThemeColors`
-- @realm shared
-- @tparam string key The key of the color.
-- @tparam Color color The color.
function mvp.meta.theme:SetColor(key, color)
    self.colors[key] = color
end

--- Get's color by key from `ThemeColors`
-- @realm shared
-- @tparam string key The key of the color.
-- @treturn Color The color.
function mvp.meta.theme:GetColor(key)
    return self.colors[key]
end

--- Indicates if theme is valid
-- @realm shared
-- @treturn boolean true if theme is valid
function mvp.meta.theme:IsTheme()
    return true 
end

--- Colors scheme
-- @table ThemeColors
-- @realm shared
-- @field primary Primary color
-- @field secondary Secondary color