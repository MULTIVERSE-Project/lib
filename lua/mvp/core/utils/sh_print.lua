--- A bunch of utility functions for the rest of the codebase
-- @module mvp.utils
mvp.utils = mvp.utils or {}

local function rgb(r, g, b, a)
    return Color(r, g, b, a or 255)
end

function mvp.utils.Print(...)
    MsgC(rgb(0, 168, 255), '[MVP] ', rgb(255, 255, 255), ...)
    MsgC('\n')
end

function mvp.utils.Error(...)
    mvp.utils.Print(rgb(232, 65, 24), '[Error] ', ...)

    ErrorNoHalt('[MVP] ', ...)
end