local lang = {}

/*
    Config descriptions
*/

lang['#tagDescription'] = 'Префикс, который будет использовать база'
lang['#menuCommandDescription'] = 'Команда, которая откроет это меню'
lang['#configPopupsDescription'] = 'Определяет, будут ли уведомления об изменении конфига показываться всем или только админам'
lang['#languageDescription'] = 'Выберете язык, на котором будут отображены интерфейсы'

/*
    Config categories
*/
lang['config#Main'] = 'Основное'
lang['config#Other'] = 'Другое'

/*
    General use
*/

lang['close'] = 'Закрыть'

/*
    !mvp menu
*/
lang['config#MenuConfig'] = 'Конфиг'
lang['config#MenuModules'] = 'Модули'
lang['config#MenuPermissions'] = 'Права'

/*
    !mvp menu strings
*/
lang['config#Configuration'] = 'Конфигурация для модулей и базы'

lang['config#Modules'] = 'Список всех загружееных модулей'
lang['config#ModulesRefresh'] = 'Проверить наличие обновлений'
lang['config#ModulesFetching'] = 'Проверяем наличие обновлений'
lang['config#ModulesUpToDate'] = 'Последняя версия!'
lang['config#ModulesNeedsUpdate'] = 'Необходимо обновление!'
lang['config#ModulesNoInformation'] = 'Нет информации о модуле!'
lang['config#ModulesNewVersion'] = 'Новая версия - %s'
lang['config#ModulesAuthor'] = 'Автор %s'

lang['config#Permissions'] = 'Список прав CAMI, которые были зарегстрированы базой или модулями'
lang['config#PermissionsDefaultAccess'] = 'Стандартный доступ %s'

/*
    Thank you screen
    Please, if you translating this, don't change our message to server owners.
*/
lang['thx#FirstLine'] = 'Огромное вам спасибо'
lang['thx#SecondLine'] = 'за использование наших скриптов'
lang['thx#MainText'] = [[В MULTIVERSE Project мы хотим делать только уникальный, интересный и крутой контент, и вы уже стали частью нашего небольшого сообщества. Спасибо за поддержку и использование нашей работы на вашем сервере!

Это сообщение появится только один раз и только для СуперАдминов, мы не будем беспокоить ваших игроков.

Если кто-то посоветовал вам установить нашу базу и пару модулей для нее, и вы еще не знаете, что у нас есть дискорд, пожалуйста, зайдите и посмотрите :)]]
-- lang['thx#DiscordURL'] = 'Открыть наш Дискорд'

mvp.language.AddTranslation('ru', lang)