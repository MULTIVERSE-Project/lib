--- @classmod Module

mvp.meta = mvp.meta or {}

mvp.meta.module = mvp.meta.module or {
    m_Version = 'Unknown',
    m_Author = 'Unknown',
    m_Description = 'No description provided',
}

MVP_HOOK_CACHE = MVP_HOOK_CACHE or {}

for name, modules in pairs(MVP_HOOK_CACHE) do
    for module, hooks in pairs(modules) do
        for id, _ in pairs(hooks) do
            hook.Remove(name, 'mvp.generatedHook.' .. module .. '.' .. id)
            MVP_HOOK_CACHE[name][id] = nil
        end
    end
end

AccessorFunc(mvp.meta.module, 'm_ID', 'ID')
AccessorFunc(mvp.meta.module, 'm_Name', 'Name')
AccessorFunc(mvp.meta.module, 'm_Description', 'Description')
AccessorFunc(mvp.meta.module, 'm_Author', 'Author')
AccessorFunc(mvp.meta.module, 'm_Version', 'Version')

AccessorFunc(mvp.meta.module, 'm_Icon', 'Icon')

-- AccessorFunc(mvp.meta.module, 'm_Enabled', 'Enabled')

AccessorFunc(mvp.meta.module, 'm_Path', 'Path')


--- Includes a file relative to the module's directory.
-- @realm shared
-- @tparam string path The file to include.
function mvp.meta.module:Include(path)
    if self:GetDisabled() then
        return 
    end

    mvp.loader.LoadFile(self:GetPath() .. '/' .. path)
end

--- Includes a folder relative to the module's directory.
-- @realm shared
-- @tparam string path The folder to include.
function mvp.meta.module:IncludeFolder(path)
    if self:GetDisabled() then
        return 
    end

    mvp.loader.LoadFolder(self:GetPath() .. '/' .. path, true )
end

--- Creates always unique hook for module.
-- @realm shared
-- @tparam string name The name of the hook.
-- @tparam function func The function to call.
-- @tparam[opt] string customID Custom ID for hook.
-- @treturn string The hook ID.
function mvp.meta.module:Hook(name, func, customID)
    if self:GetDisabled() then
        return 
    end

    local isCustomIDGenerated = false
    
    if not customID then
        customID = mvp.utils.UUID(6)
        isCustomIDGenerated = true
    end

    MVP_HOOK_CACHE[name] = MVP_HOOK_CACHE[name] or {}
    MVP_HOOK_CACHE[name][self:GetName()] = MVP_HOOK_CACHE[name][self:GetName()] or {}

    if MVP_HOOK_CACHE[name][self:GetName()][customID] then
        if isCustomIDGenerated then
            return self:Hook(name, func)
        else
            error('Hook with customID "' .. customID .. '" already exists!')
        end
    end

    MVP_HOOK_CACHE[name][self:GetName()][customID] = true

    hook.Add(name, 'mvp.generatedHook.' .. self:GetName() .. '.' .. customID, function(...)
        return func(self, ...)
    end)

    return customID
end

--- Disables module.
-- You need server restart to apply changes.
--
-- This should be used only on server side to take effect, although it will work on client side too, but will have no effect.
-- @realm shared
-- @tparam bool disabled Should module be disabled?
function mvp.meta.module:SetDisabled(disabled)
    local info = mvp.data.Get('disabled_modules', {}, false, true)

    if disabled then
        info[self:GetID()] = true
    else
        info[self:GetID()] = nil
    end

    mvp.data.Set('disabled_modules', info, false)
end

--- Checks if module is disabled
-- @realm shared
-- @treturn bool is module disabled
function mvp.meta.module:GetDisabled()
    local info = mvp.modules.disabledModules or mvp.data.Get('disabled_modules', {})

    return info[self:GetID()] or false
end