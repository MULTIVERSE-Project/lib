mvp.config.Add('chatCommand', '!mvp', 'Chat command to open MULTIVERSE menu', nil, {
    category = 'base'
})

mvp.config.Add('configPopups', false, 'Controls if every player can see congig popups', nil, {
    category = 'base'
})

mvp.config.Add('allowConsoleCommand', true, 'Controls if menu console command enabled', nil, {
    category = 'base' 
})

mvp.config.Add('language', 'en', 'Language to use', nil, {
    category = 'base',
    type = 'select', -- type for UI
    
    OnPopulateValues = function(comboBox)
        comboBox:AddChoice('en', 'English')
        comboBox:AddChoice('wip', 'WIP')
        comboBox:AddChoice('wip', 'WIP')
        comboBox:AddChoice('wip', 'WIP')
    end
})

mvp.config.Add('tag', '[MVP]', 'Tag to show in chat when library (or module) send a message', nil, {
    category = 'appearence'
})

mvp.config.Add('theme', 'default', 'Theme to use', nil, {
    category = 'appearence'
}) 

mvp.config.Add('testArrayStrings', {['hello'] = 'world'}, 'Test array', nil, {
    category = 'testing',

    type = mvp.type.array,

    key = {type = mvp.type.string, hint = 'Key hint'},
    value = {type = mvp.type.string, hint = 'Value hint'},
})
 
mvp.config.Add('testArrayBools', {['hello'] = true, ['world'] = false}, 'Test array', nil, {
    category = 'testing',

    type = mvp.type.array,
    key = {type = mvp.type.string},
    value = {type = mvp.type.bool},
})