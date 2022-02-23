mvp.config.Add('language', 'en', '#languageDescription', nil, {
    category = 'config#Main',
    type = 'select',
    from = mvp.language.GetLoadedLanguages
}, false, false)