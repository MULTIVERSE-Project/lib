--- @classmod Panel

local PANEL = FindMetaTable('Panel')

--- Helper function to set metafunctions wothout havimg to override the metatable.
-- @realm client
-- @tparam string name Name of the metafunction.
-- @tparam function func Function to set.
-- @treturn Panel Self.
function PANEL:On(name, func)
    
    local old = self[name]

    self[name] = function(s, ...)
        if old then
            old(s, ...)
        end
        func(s, ...)
    end

    return self
end

--- Lerping function.
-- @realm client
-- @tparam string var Variable to lerp.
-- @tparam number to To value.
-- @tparam number duration duration of the lerp.
-- @tparam function callback Callback to call when the lerp is finished.
function PANEL:Lerp(var, to, duration, callback)
    local value = self[var]

    local a = self:NewAnimation(duration, 0, 0.5, callback)

    a.value = to
    a.Think = function(anim, pnl, fraction)

        local newFraction = mvp.ui.Ease(fraction, 0, 1, 1)
        
        if not anim.startValue then
            anim.startValue = self[var]
        end
        
        local newColor = Lerp(newFraction, anim.startValue, anim.value)
        self[var] = newColor
    end
end

--- Color lerping function.
-- @realm client
-- @tparam string var Variable to lerp.
-- @tparam Color to To value.
-- @tparam number duration duration of the lerp.
-- @tparam function callback Callback to call when the lerp is finished.
function PANEL:LerpColor(var, to, duration, callback)
    local color = self[var]

    local a = self:NewAnimation(duration)

    a.color = to
    a.Think = function(anim, pnl, fraction)

        local newFraction = mvp.ui.Ease(fraction, 0, 1, 1)
        
        if not anim.startColor then
            anim.startColor = self[var]
        end
                
        local newColor = mvp.utils.LerpColor(newFraction, anim.startColor, anim.color)
        self[var] = newColor
    end
end