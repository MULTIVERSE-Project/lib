mvp = mvp or {}
mvp.language = mvp.language or {}
mvp.language.keys = mvp.language.keys or {}
mvp.language.list = mvp.language.list or {}

FALLBACK_LANGUAGE = 'en'

function mvp.language.RegisterKey(key)
    mvp.language.keys[key] = true
end

function mvp.language.AddTranslation(lang, tbl)
    
    for k, v in tbl do
        if not mvp.language.keys[k] then 
            tbl[k] = nil
        end
    end

    if mvp.language.list[lang] then
        table.Merge(mvp.language.list[lang], tbl)
        return 
    end

    mvp.language.list[lang] = tbl
end

function mvp.language.Get(key)
    local selectedLanguage = mvp.language.GetActiveLanguage() 

    if not mvp.language.list[selectedLanguage] then
        return key .. '#noLanguageFinded'
    end

    local lang = mvp.language.list[selectedLanguage]

    if not lang[key] then
        return mvp.language.list[FALLBACK_LANGUAGE][key] or key
    end
end

function mvp.language.Load()
    mvp.utils.IncludeFolder('languages', false, false)
end

function mvp.language.GetActiveLanguage() 
    return mvp.config.Get('language')
end

function mvp.language.GetLoadedLanguages()
    local result = {}
    for k, v in pairs(mvp.language.list) do
        result[k] = true
    end

    return result
end
