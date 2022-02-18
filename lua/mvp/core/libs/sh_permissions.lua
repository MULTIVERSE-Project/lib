---@module mvp.permission

mvp = mvp or {}
mvp.permission = mvp.permission or {}
mvp.permission.list = mvp.permission.list or {}

--- Добавляет право с систему CAMI
-- @realm shared
-- @string name Название привелегии
-- @string[opt=admin] minAccess Минимальный доступ. `user`, `admin`, `superadmin`.
-- @string[opt=nil] description Описание привелегии
function mvp.permission.Add(name, minAccess, description)
    if not name then
        Error('Попытка зарегистрировать привелегию без названия.')
        return 
    end
    
    local privilege = {
        Name = name,
        MinAccess = minAccess or 'admin',
        Description = description or 'Без описания'
    }

    mvp.permission.list[name] = privilege
    CAMI.RegisterPrivilege(privilege)
end

--- Проверяет есть ли у игрока привелегия
-- @realm shared
-- @tparam Player actor Игрок
-- @string permission Привелегия
-- @treturn[1] boolean Имеет ли игрок доступ
-- @treturn[1] string reason Причина
function mvp.permission.Check(actor, permission)
    local hasAccess, reason = CAMI.PlayerHasAccess(actor, permission)

    return hasAccess, reason
end

function mvp.permission.CheckBoth(actor, permission1, permission2)
    local hasAccess1, reason1 = CAMI.PlayerHasAccess(actor, permission1)
    local hasAccess2, reason2 = CAMI.PlayerHasAccess(actor, permission2)

    return hasAccess1 and hasAccess2, reason1, reason2
end

--- Получает все привелегии, которые зарегистирированы.
-- @realm shared
-- @treturn table Все привелегии
function mvp.permission.GetAllPermissions()
    return CAMI.GetPrivileges()
end

--- Получает только привелегии режима.
-- @realm shared
-- @treturn table Привелегии, зарегистированые через `Add`
function mvp.permission.GetLibPermissions()
    return mvp.permission.list
end