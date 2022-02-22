mvp = mvp or {}

mvp.name = 'MULTIVERSE Project Base'
mvp.description = 'A set of utilities and interfaces for MVP scripts.'
mvp.version = '1.0.0'
mvp.author = 'Kot'

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

concommand.Add('mvp_hotreload', function(ply)
    if IsValid(ply) then
        print('This command can be executed only by server console!')
        return 
    end

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
    
    net.Start('mvpHotReload')
    net.Broadcast()
end)