--- @module mvp.ui
mvp.ui = mvp.ui or {}

--- Default easing function
-- @realm client
-- @tparam number t
-- @tparam number b
-- @tparam number c
-- @tparam number d
function mvp.ui.Ease(t, b, c, d)
    t = t / d
    local ts = t * t
    local tc = ts * t
  
  
    return b + c * (-2 * tc + 3 * ts)
end
  