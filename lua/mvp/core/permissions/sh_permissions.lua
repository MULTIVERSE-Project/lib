--- @module mvp.permissions

mvp.permissions = mvp.permissions or {}

mvp.permissions.list = mvp.permissions.list or {}

--- Table containing information about a permission
-- @table Permission
-- @realm shared
-- @field Name The name of the permission
-- @field Description The description of the permission
-- @field MinAccess The default access for the permission

--- Adds a permission to the list of permissions.
-- @realm shared
-- @tparam string name The name of the permission.
-- @tparam[opt="admin"] string default The default access for the permission.
-- @tparam[opt] string description The description of the permission.
function mvp.permissions.Add( name, default, description )
    if not name then
        error( "No name specified for permission" )
    end

    local privilege = {
        Name = name,
        Description = description or 'This permission has no description',
        MinAccess = default or 'admin'
    }

    mvp.permissions.list[name] = privilege

    CAMI.RegisterPrivilege(privilege)
end

--- Checks if a player has a permission.
-- @realm shared
-- @tparam Player ply The player to check.
-- @tparam string name The name of the permission.
-- @treturn[1] bool Whether the player has the permission.
-- @treturn[1] string Reason why player don't have permission, if any returned by admin mode.
function mvp.permissions.Check( ply, name )
    local hasAccess, reason = CAMI.PlayerHasAccess(ply, name)

    return hasAccess, reason
end

--- Gets permission by name.
-- @realm shared
-- @tparam string name The name of the permission.
-- @treturn Permission The permission.
function mvp.permissions.Get( name )
    return mvp.permissions.list[name]
end

--- Gets all permissions.
-- @realm shared
-- @treturn table Table of `Permission`s that containing all permissions registered by lib and modules.
function mvp.permissions.GetAll()
    return mvp.permissions.list
end