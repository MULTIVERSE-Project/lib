local lang = {}

-- Just ordinary strings. Used for text.
lang['menuTitle'] = 'Меню MULTIVERSE'
lang['menuHome'] = 'Главная'
lang['menuConfig'] = 'Конфигурация'
lang['menuModules'] = 'Модули'
lang['menuPermissions'] = 'Права'
lang['menuAbout'] = 'Об MULTIVERSE'

lang['aboutCreatedBy1'] = 'Создал %s'
lang['aboutCreatedBy2'] = 'Создано %s и %s'
lang['aboutJoinDiscord'] = 'Дискорд'

lang['configUnsaved'] = 'Несохраненные изменения'
lang['configPleaseSave'] = 'Пожалуйста, сохраните изменения перед выходом.'
lang['configEdit'] = 'Редактировать'
lang['configEditField'] = 'Редактировать %s'

lang['arrayManagerTitle'] = 'Менеджер таблиц'
lang['arrayManagerHint1'] = 'Это менеджер таблиц. Здесь можно добавлять, удалять и редактировать записи.'
lang['arrayManagerHint2'] = 'Используйте значок "плюс", чтобы добавить новую запись, или значок "удалить" рядом с существующей записью, чтобы удалить ее.'
lang['arrayManagerHint3'] = 'Значения будут автоматически сохранены в вашем менеджере конфигурации, как только вы закроете это окно.'

-- Keys prefixed with "@" symbol are used for translating config keys, descriptions and categories.
-- Keys suffixed with "_Desc" are used for translating config descriptions.
-- Keys suffixed with "_Cat" are used for translating config categories.
lang['@other_Cat'] = 'Другое'
lang['@base_Cat'] = 'Основное'
lang['@appearance_Cat'] = 'Внешний вид'

lang['@allowConsoleCommand'] = 'Разрешить консольную команду'
lang['@allowConsoleCommand_Desc'] = 'Контролирует, включена ли консольная команда для открытия меню MULTIVERSE.'
lang['@configPopups'] = 'Всплывающие окна конфига'
lang['@configPopups_Desc'] = 'Контролирует, отображаются ли всплывающие окна при редактировании конфига.'
lang['@chatCommand'] = 'Команда для чата'
lang['@chatCommand_Desc'] = 'Команда, которая будет использоваться для открытия меню MULTIVERSE.'
lang['@language'] = 'Язык'
lang['@language_Desc'] = 'Язык, который будет использоваться.'
lang['@tag'] = 'Тег'
lang['@tag_Desc'] = 'Тег, который будет использоваться перед сообщениями в чате.'
lang['@theme'] = 'Тема'
lang['@theme_Desc'] = 'Оформление, которое будет использоваться.'

mvp.languages.Register('ru', lang)