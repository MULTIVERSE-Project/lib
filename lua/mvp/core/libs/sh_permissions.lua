mvp = mvp or {}
mvp.permission = mvp.permission or {}
mvp.permission.list = mvp.permission.list or {}

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

function mvp.permission.Check(actor, permission)
    local hasAccess, reason = CAMI.PlayerHasAccess(actor, permission)

    return hasAccess, reason
end

function mvp.permission.CheckBoth(actor, permission1, permission2)
    local hasAccess1, reason1 = CAMI.PlayerHasAccess(actor, permission1)
    local hasAccess2, reason2 = CAMI.PlayerHasAccess(actor, permission2)

    return hasAccess1 and hasAccess2, reason1, reason2
end

function mvp.permission.GetAllPermissions()
    return CAMI.GetPrivileges()
end

function mvp.permission.GetLibPermissions()
    return mvp.permission.list
end