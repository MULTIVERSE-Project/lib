--- Loader for the library. 
-- @module mvp.loader

mvp = mvp or {}

mvp.loader = mvp.loader or {}
mvp.loader.relativePath = 'mvp/'

local function rgb(r, g, b, a)
    return Color(r, g, b, a or 255)
end

local function p(...)
    if mvp.utils and mvp.utils.Print then
        return mvp.utils.Print(...)
    end

    MsgC(rgb(0, 168, 255), '[MVP]', rgb(225, 177, 44), '[Loader] ', rgb(255, 255, 255), ...)
    MsgC('\n')
end

--- Sends and loads client files.
-- Should be called only on shared!
-- @realm shared
-- @param path Path to the file to load.
function mvp.loader.LoadCLFile(path)
    if SERVER then
        AddCSLuaFile(path)
    else
        include(path)
    end
    
    p('Loaded ', rgb(68, 189, 50), 'CL', rgb(255, 255, 255), ' file: ', path)
end


--- Loads server files.
-- It won't do anything if called on client.
-- @realm shared
-- @param path Path to the file to load.
function mvp.loader.LoadSVFile(path)
    if SERVER then
        include(path)
    end

    p('Loaded ', rgb(0, 151, 230), 'SV', rgb(255, 255, 255), ' file: ', path)
end

--- Send and loads client files.
-- Should be called only on shared!
-- @realm shared
-- @param path Path to the file to load.
function mvp.loader.LoadSHFile(path)
    if SERVER then
        AddCSLuaFile(path)
    end
    include(path)

    p('Loaded ', rgb(140, 122, 230), 'SH', rgb(255, 255, 255), ' file: ', path)
end

--- Send and loads files.
-- This function will determine if the file is a client file, server file or shared file and call the appropriate function.
-- @realm shared
-- @tparam string path Path to the file to load.
function mvp.loader.LoadFile(path)
    print(path)
    if path:find('cl_') then
        mvp.loader.LoadCLFile(path)
    elseif path:find('sv_') then
        mvp.loader.LoadSVFile(path)
    else
        mvp.loader.LoadSHFile(path)
    end
end

--- Loads all files in a directory.
-- @realm shared
-- @tparam string path Path to the directory to load.
-- @tparam[opt=false] boolean fromLua If true, the path will be relative to the lua/ folder.
function mvp.loader.LoadFolder(path, fromLua)
    path = (fromLua and '' or mvp.loader.relativePath) .. path
    print(path)
    local files, folders = file.Find(path .. '/*', 'LUA')

    for _, file in pairs(files) do
        mvp.loader.LoadFile(path .. '/' .. file)
    end

    for _, folder in pairs(folders) do
        mvp.loader.LoadFolder(path .. '/' .. folder)
    end
end