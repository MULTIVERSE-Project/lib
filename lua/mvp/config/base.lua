mvp.config.Add('chatCommand', '!mvp', nil, {
    category = 'base'
})

mvp.config.Add('configPopups', false, nil, {
    category = 'base'
})

mvp.config.Add('allowConsoleCommand', true, nil, {
    category = 'base' 
})

mvp.config.Add('language', 'en', nil, {
    category = 'base',
    type = 'select', -- type for UI
    
    GetValues = function()
        local languages = mvp.languages.list

        local values = {}
        for k, v in pairs(languages) do
            values[#values + 1] = {value = k, text = mvp.languages.langCodes[k] or 'Please use ISO 639-1 Alpha-2 language code'}
        end

        return values
    end
})

mvp.config.Add('currency', 'blank', nil, {
    category = 'base',
    type = 'select', -- type for UI
    
    GetValues = function()
        local currencies = mvp.currencies.list

        local values = {}
        for k, v in pairs(currencies) do
            values[#values + 1] = {value = k, text = k}
        end

        return values
    end
})

mvp.config.Add('tag', '[MVP]', nil, {
    category = 'appearance'
})

mvp.config.Add('theme', 'MVP Default Dark Theme', nil, {
    category = 'appearance',
    type = 'select',

    GetValues = function()
        local themes = mvp.themes.list
        local values = {}

        for k, v in pairs(themes) do
            print(k, v)
            values[#values + 1] = {value = k, text = k}
        end

        PrintTable(values)

        return values
    end
})