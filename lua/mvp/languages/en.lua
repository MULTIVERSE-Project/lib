local lang = {}

/*
    Config descriptions
*/

lang['#tagDescription'] = 'Tag that base will use'
lang['#menuCommandDescription'] = 'Command that will open this menu'
lang['#configPopupsDescription'] = 'Determines if base should show config changes to all players, or only to admins'

/*
    Config categories
*/
lang['config#Main'] = 'Main'
lang['config#Other'] = 'Other'

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

mvp.language.AddTranslation('en', lang)