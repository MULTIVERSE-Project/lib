--- @module mvp.languages

mvp.languages = mvp.languages or {}
mvp.languages.list = mvp.languages.list or {}

--- Adds a language to the list of available languages.
-- @realm shared
-- @tparam string id The language ID
-- @tparam table lang The language table
function mvp.languages.Register(id, lang)
    if not mvp.languages.list[id] then
        mvp.languages.list[id] = lang

        return mvp.languages.list[id]
    end

    local oldLang = mvp.languages.list[id]

    for k, v in pairs(lang) do
        oldLang[k] = v
    end

    mvp.languages.list[id] = oldLang

    return mvp.languages.list[id]
end

--- Gets a language from the list of available languages.
-- @realm shared
-- @tparam string id The language ID
function mvp.languages.Get(id)
    return mvp.languages.list[id]
end

--- Gets and formats a string from a language.
-- @realm shared
-- @tparam string key The key of the string
-- @tparam any ... The arguments to format the string with
function mvp.languages.GetString(key, ...)
    local lang = mvp.languages.Get(mvp.config.Get("language"))

    if not lang then
        return key
    end

    local str = lang[key]

    if not str then
        return key
    end

    return string.format(str, ...)
end

--- Loads all languages from the specified folder.
-- @internal
-- @realm shared
-- @tparam string path The path to the folder
function mvp.languages.LoadFromFolder(path)
    mvp.loader.LoadFolder(path, true)
end

--- Initializes the language system.
-- @internal
-- @realm shared
function mvp.languages.Init()
    mvp.languages.LoadFromFolder("mvp/languages")
end

--- @module mvp

--- Shortcut for `mvp.languages.GetString`
-- @realm shared
-- @tparam string key Key of the language string
-- @tparam[opt] any ... Any values to be formatted into the string
function mvp.Lang(key, ...)
    return mvp.languages.GetString(key, ...)
end