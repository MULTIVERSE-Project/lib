--- Top-level library containing all MVP libraries. A large majority of the library is split into respective libraries that
-- reside within `mvp`.
-- @module mvp
mvp = mvp or {}

--- A table of variable types that are used throughout the framework. It represents types as a table with the keys being the
-- name of the type, and the values being some number value. **You should never directly use these number values!** Using the
-- values from this table will ensure backwards compatibility if the values in this table change.
--
-- This table also contains the numerical values of the types as keys. This means that if you need to check if a type exists, or
-- if you need to get the name of a type, you can do a table lookup with a numerical value. Note that special types are not
-- included since they are not real types that can be compared with.
-- @table mvp.type
-- @realm shared
-- @field string A regular string.
-- @field number Any number.
-- @field player Any player that matches the given query string in `mvp.util.FindPlayer`.
-- @field steamid A string that matches the Steam ID format of `STEAM_X:X:XXXXXXXX`.
-- @field bool A string representation of a bool - `false` and `0` will return `false`, anything else will return `true`.
-- @field color A color represented by its red/green/blue/alpha values.
-- @field vector A 3D vector represented by its x/y/z values.
-- @field array Any table.
-- @usage -- checking if type exists
-- print(mvp.type[2] ~= nil)
-- > true
--
-- -- getting name of type
-- print(mvp.type[mvp.type.string])
-- > 'string'

--[[

    ==============================
     Loading sequence starts here
    ==============================

]]--

-- Load thirdparty libraries 
mvp.loader.LoadFolder('thirdparty') 

-- Load utilites
mvp.loader.LoadFolder('core/utils')
-- Load data manager
mvp.loader.LoadFolder('core/data')
-- Load permissions manager
mvp.loader.LoadFolder('core/permissions')

-- Load metatables
mvp.loader.LoadFolder('core/meta')
-- Load config
mvp.loader.LoadFolder('core/config')
mvp.config.Load()

-- Load currencies support (@todo make this "gamemodes" support)
mvp.loader.LoadFolder('core/currencies')
mvp.currencies.Init()

-- Load languages
mvp.loader.LoadFolder('core/languages') 
mvp.languages.Init()

-- Load themes
mvp.loader.LoadFolder('core/themes')
mvp.themes.Load() 
-- Load fonts
mvp.loader.LoadFolder('core/fonts')
mvp.themes.Load() 
 
-- Load UI system
mvp.loader.LoadFolder('core/ui')
-- Load UI elements
mvp.loader.LoadFolder('terminal/vgui')
mvp.loader.LoadFolder('menus')

-- Load modules
mvp.loader.LoadFolder('core/modules')
mvp.modules.Init()

--[[

    ==============================
      Loading sequence ends here
    ==============================

]]--

mvp.permissions.Add('mvp.admin', 'admin', 'Allows access to all MVP admin commands.')