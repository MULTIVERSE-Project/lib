local lang = {}

/*
    Config descriptions
*/

lang['#tagDescription'] = 'Tag that base will use'
lang['#menuCommandDescription'] = 'Command that will open this menu'
lang['#configPopupsDescription'] = 'Determines if base should show config changes to all players, or only to admins'
lang['#languageDescription'] = 'Select the language in which the interfaces will be displayed'

/*
    Config categories
*/
lang['config#Main'] = 'Main'
lang['config#Other'] = 'Other'

/*
    General use
*/

lang['close'] = 'Close'

/*
    !mvp menu
*/
lang['config#MenuConfig'] = 'Config'
lang['config#MenuModules'] = 'Modules'
lang['config#MenuPermissions'] = 'Permissions'

/*
    !mvp menu strings
*/
lang['config#Configuration'] = 'Configuration for base and modules'

lang['config#Modules'] = 'List of all loaded modules for base'
lang['config#ModulesRefresh'] = 'Check for avaible updates'
lang['config#ModulesFetching'] = 'Checking for avaible updates'
lang['config#ModulesUpToDate'] = 'Up-to-date!'
lang['config#ModulesNeedsUpdate'] = 'Needs update!'
lang['config#ModulesNoInformation'] = 'No information about module!'
lang['config#ModulesNewVersion'] = 'New version %s'
lang['config#ModulesAuthor'] = 'Author %s'

lang['config#Permissions'] = 'List of CAMI permissions registered by base and modules'
lang['config#PermissionsDefaultAccess'] = 'Default access %s'

/*
    Thank you screen
    Please, if you translating this, don't change our message to server owners.
*/
lang['thx#FirstLine'] = 'Thank you very much'
lang['thx#SecondLine'] = 'for using our scripts'
lang['thx#MainText'] = [[At MULTIVERSE Project we want to make only unique, interesting and cool content, and you've ALREADY become part of our small community. Thank you for supporting and using our work on your server!

This message will only appear once, and only to the SuperAdmins, we won't disturb your players.

If someone recommended you to install our base and a couple of modules for it and you don't know yet that we have a discord, please come and take a look :)]]
lang['thx#DiscordURL'] = 'Open link to Discord server'

mvp.language.AddTranslation('en', lang)