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
    
    OnPopulateValues = function(comboBox)
        comboBox:AddChoice('en', 'English')
        comboBox:AddChoice('wip', 'WIP')
        comboBox:AddChoice('wip', 'WIP')
        comboBox:AddChoice('wip', 'WIP')
    end
})

mvp.config.Add('tag', '[MVP]', nil, {
    category = 'appearence'
})

mvp.config.Add('theme', 'default', nil, {
    category = 'appearence'
}) 

mvp.config.Add('testArrayStrings', {['hello'] = 'world'}, nil, {
    category = 'testing',

    type = mvp.type.array,

    key = {type = mvp.type.string, hint = 'Key hint'},
    value = {type = mvp.type.string, hint = 'Value hint'},
})
 
mvp.config.Add('testArrayBools', {['hello'] = true, ['world'] = false}, nil, {
    category = 'testing',

    type = mvp.type.array,
    key = {type = mvp.type.string},
    value = {type = mvp.type.bool},
})