mvp = mvp or {}
mvp.language = mvp.language or {}
mvp.language.keys = mvp.language.keys or {}
mvp.language.list = {}

FALLBACK_LANGUAGE = 'en'

function mvp.language.RegisterKey(key)
    mvp.language.keys[key] = true
end

function mvp.language.AddTranslation(lang, tbl)    
    for k, v in pairs(tbl) do
        if lang == FALLBACK_LANGUAGE then 
            mvp.language.RegisterKey(k)

            continue
        end

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

    return lang[key]
end

function mvp.language.Load()
    mvp.language.LoadFromDir('mvp/languages')
end

function mvp.language.LoadFromDir(path)
    local files, folders = file.Find(path .. '/*.lua', 'LUA')

    for k, v in pairs(files) do
        mvp.utils.Include(path .. '/' .. v, 'shared')
    end
end

function mvp.language.GetActiveLanguage() 
    return mvp.config.Get('language')
end

function mvp.language.GetLoadedLanguages()
    local result = {}
    local keysCount = table.Count(mvp.language.keys)

    for k, v in pairs(mvp.language.list) do
        local keysInLanguageCount = table.Count(v)

        result[k] = string.upper(k) .. ', translated ' .. (math.Round((keysInLanguageCount / keysCount) * 100)) .. '%'
    end

    return result
end
