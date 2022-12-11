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

    MsgC(Color(0, 168, 255), '[MVP]', Color(225, 177, 44), '[Loader] ', Color(255, 255, 255), ...)
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
    
    p(Color(255, 174, 0), '▐▌', color_white, ' Loaded ', Color(255, 174, 0), 'CL', Color(255, 255, 255), ' file: ', path)
end


--- Loads server files.
-- It won't do anything if called on client.
-- @realm shared
-- @param path Path to the file to load.
function mvp.loader.LoadSVFile(path)
    if SERVER then
        include(path)
    end

    p(Color(0, 102, 255), '▐▌', color_white, ' Loaded ', Color(0, 102, 255), 'SV', Color(255, 255, 255), ' file: ', path)
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

    p(Color(255, 174, 0), '▐', Color(0, 102, 255), '▌', color_white, ' Loaded ', Color(255, 174, 0), 'S', Color(0, 102, 255), 'H', Color(255, 255, 255), ' file: ', path)
end

--- Send and loads files.
-- This function will determine if the file is a client file, server file or shared file and call the appropriate function.
-- @realm shared
-- @tparam string path Path to the file to load.
function mvp.loader.LoadFile(path, realm)
	if ((realm == 'server' or path:find('sv_')) and SERVER) then
		return mvp.loader.LoadSVFile(path)
	elseif (realm == 'client' or path:find('cl_')) then
		return mvp.loader.LoadCLFile(path)
    else
        return mvp.loader.LoadSHFile(path)
    end
end

--- Loads all files in a directory.
-- @realm shared
-- @tparam string path Path to the directory to load.
-- @tparam[opt=false] boolean fromLua If true, the path will be relative to the lua/ folder.
function mvp.loader.LoadFolder(path, fromLua)
    path = (fromLua and '' or mvp.loader.relativePath) .. path

    local files, folders = file.Find(path .. '/*', 'LUA')

    for _, file in pairs(files) do
        mvp.loader.LoadFile(path .. '/' .. file)
    end

    for _, folder in pairs(folders) do
        mvp.loader.LoadFolder(path .. '/' .. folder)
    end
end