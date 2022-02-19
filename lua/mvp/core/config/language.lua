-- mvp.config.Add('lang', 'ru', 'Язык, который будет использован для интерфейсов сервера', nil, {category = 'Основное', type = 'select', from = mvp.language.GetAvaibleLangs}, false, false)
mvp.config.Add('language', 'en', '#languageDescription', nil, {
    category = 'config#Main',
    type = 'select',
    from = mvp.language.GetLoadedLanguages
}, false, false)