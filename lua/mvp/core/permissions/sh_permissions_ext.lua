--- @module mvp

--- Shortcut for `mvp.permissions.Check`
-- @realm shared
-- @tparam Player ply The player to check.
-- @tparam string name The name of the permission.
-- @treturn[1] bool Whether the player has the permission.
-- @treturn[1] string Reason why player don't have permission, if any returned by admin mode.
function mvp.Perm(ply, name)
    return mvp.permissions.Check( ply, name )
end