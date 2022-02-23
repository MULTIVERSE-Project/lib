mvp = mvp or {}

net.Receive('mvpHotReload', function()
    mvp = mvp or {}

    include('mvp/core/sh_utils.lua')
    include('mvp/core/sh_data.lua')
    include('mvp/core/sh_config.lua')

    mvp.utils.IncludeFolder('core/libs/thirdparty', false, true)
    mvp.utils.IncludeFolder('core/libs', false, true, {
        ['thirdparty'] = true
    })

    mvp.utils.IncludeFolder('core/ui', false, true)
    mvp.utils.IncludeFolder('interface', false, true)

    mvp.module.Init() 
    mvp.config.Load()
    mvp.language.Load()

    mvp.utils.Popup(5, nil, nil, 'MVP lib reloaded!')
end)