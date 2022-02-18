mvp = mvp or {}
mvp.language = mvp.language or {}
mvp.language.loaded = {}
mvp.language.avaibleIDs = {}
mvp.language.languageParams = {}

function mvp.language.Register(id)
    mvp.language.loaded[id] = {}
    mvp.language.avaibleIDs[id] = true
end

function mvp.language.Set(id, param, value)
    mvp.language.loaded[id][param].translation = value

    mvp.language.Save()
end

function mvp.language.Add(param, default)
    mvp.language.languageParams[param] = default
end

function mvp.language.Save()
    local values = mvp.language.GetChangedVars()

    mvp.data.Set('language', values, true)
end

function mvp.language.Load()
    local data = mvp.data.Get('language', {}, true, true)

    for id, params in pairs(data) do
        if not mvp.language.loaded[id] then
            mvp.language.Register(id) -- register this lang
        end

        for param, translation in pairs(params) do
            if not mvp.language.languageParams[param] then continue end -- this param no longer in use

            mvp.language.loaded[id][param] = translation
        end
    end
end

function mvp.language.GetChangedVars()
    local result = {}
    for id, lang in pairs(mvp.language.loaded) do
        for param, value in pairs(lang) do
            if value.translation and value.translation ~= '' then
                if not result[id] then result[id] = {} end

                result[id][param] = value.translation
            end
        end
    end

    return result
end

function mvp.language.Get(param)
    local activeLanguage = mvp.language.GetActiveLanguage()

    if not mvp.language.loaded[activeLanguage] then
        return mvp.language.languageParams[param] or param
    end

    if mvp.language.loaded[activeLanguage][param] and mvp.language.loaded[activeLanguage].translation then
        return mvp.language.loaded[activeLanguage][param].translation
    end

    return mvp.language.loaded[activeLanguage][param].default or param
end

function mvp.language.GetActiveLanguage()
    return mvp.config.Get('lang', 'en') 
end