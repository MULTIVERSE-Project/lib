-- ==========================================================================================
-- ⚠
-- НЕ НУЖНО НИЧЕГО МЕНЯТЬ В ЭТОМ ФАЙЛЕ
-- ЭТОТ ФАЙЛ ОТВЕЧЕТ ЗА АВТОМАТИЧЕСКУЮ ГЕНЕРАЦИЮ, УПРАВЛЕНИЕ И ИЗМИНЕНИЕ КОНФИГУРАЦИИ СЕРВЕРА
-- ⚠
-- ==========================================================================================

--
-- Глобальные переменные
--

-- mvp.config.Add('title', GetHostName(), 'Название сервера. Советую писать полное название без всяких [RU][RP][PENIS].', nil, {category = 'Основное', type = 'string'}, false, false)
-- mvp.config.Add('subtitle', 'MULTVERSE Project.', 'Подзаголовок сервера.', nil, {category = 'Основное', type = 'string'}, false, false)
-- mvp.config.Add('shortDescription', 'MULTVERSE Derived Project', 'Краткое описание сервера, будет показано новым игрокам', nil, {category = 'Основное', type = 'longString'}, false, false)

mvp.config.Add('mvpTag', 'MVP', 'Tag that base will use', nil, {category = 'Main', type = 'string'}, false, false) 
mvp.config.Add('mvpCommand', '!mvp', 'Command that will open this menu', nil, {category = 'Main', type = 'string'}, false, false)
mvp.config.Add('canPlayersSeeConfigPopups', false, 'Determines if base should show config changes to all players, or only to admins.', nil, {category = 'Main', type = 'bool'}, false, false) 

