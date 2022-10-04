--- @module mvp
mvp = mvp or {}

--- Shortcut for `mvp.languages.GetString`
-- @realm shared
-- @tparam string key Key of the language string
-- @tparam[opt] any ... Any values to be formatted into the string
function mvp.Lang(key, ...)
    return mvp.languages.GetString(key, ...)
end