--- @module mvp.ui
mvp.ui = mvp.ui or {}

--- Easing function for animations.
-- @realm client
-- @param t number
-- @param b number
-- @param c number
-- @param d number
-- @treturn number
function mvp.ui.Ease(t, b, c, d)
    t = t / d
    local ts = t * t
    local tc = ts * t

    return b + c * (-2 * tc + 3 * ts)
end