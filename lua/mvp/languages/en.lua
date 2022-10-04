local lang = {}

-- Just ordinary strings. Used for text.
lang['menuTitle'] = 'MULTIVERSE Menu'
lang['menuHome'] = 'Home'
lang['menuConfig'] = 'Configuration'
lang['menuModules'] = 'Modules'
lang['menuPermissions'] = 'Permissions'
lang['menuAbout'] = 'About'

lang['aboutCreatedBy1'] = 'Created by %s'
lang['aboutCreatedBy2'] = 'Created by %s & %s'
lang['aboutJoinDiscord'] = 'Join Discord'

lang['configUnsaved'] = 'UNSAVED CHANGES'
lang['configPleaseSave'] = 'Please save/reset your changes'
lang['configEdit'] = 'Edit'
lang['configEditField'] = 'Edit %s'

lang['arrayManagerTitle'] = 'Array Manager'
lang['arrayManagerHint1'] = 'This is the array manager. You can add, remove and edit entries here.'
lang['arrayManagerHint2'] = 'Use "plus" icon to add a new entry, or use "delete" icon next to existing entry to delete it.'
lang['arrayManagerHint3'] = 'Values will be auto-saved to your config manager once you close this window.'

-- Keys prefixed with "@" symbol are used for translating config keys and descriptions.
-- Keys suffixed with "_Desc" are used for translating config descriptions.
lang['@allowConsoleCommand'] = 'Allow console command'
lang['@allowConsoleCommand_Desc'] = 'Controls if menu console command enabled'
lang['@configPopups'] = 'Config popups'
lang['@configPopups_Desc'] = 'Controls if config popups enabled'
lang['@chatCommand'] = 'Chat command'
lang['@chatCommand_Desc'] = 'Chat command to open this menu'
lang['@language'] = 'Language'
lang['@language_Desc'] = 'Language of the UIs'
lang['@tag'] = 'Tag'
lang['@tag_Desc'] = 'Tag to show in chat when library (or module) send a message'
lang['@theme'] = 'Theme'
lang['@theme_Desc'] = 'Theme of the UIs'

mvp.languages.Register('en', lang)