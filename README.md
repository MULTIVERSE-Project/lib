![](https://github.com/MULTIVERSE-Project/lib/blob/main/materials/mvp/m_icons/base.png)

This is the library for our scripts. It does not contain any game content.

To open the configurator type `!mvp` into the chat.

Join our discord server > https://discord.gg/Ah5q4zqhgn

## How to create module for MVP Base

Let's start with file structure:
```
📦your_addon_folder
 ┗ 📂lua
 ┃ ┗ 📂mvp
 ┃ ┃ ┗ 📂modules
 ┃ ┃ ┃ ┗ 📂your_module_folder
 ┃ ┃ ┃ ┃ ┣ 📂any_folder
 ┃ ┃ ┃ ┃ ┃ ┣ 📜cl_anyfile.lua
 ┃ ┃ ┃ ┃ ┃ ┣ 📜sh_anyfile.lua
 ┃ ┃ ┃ ┃ ┃ ┗ 📜sv_anyfile.lua
 ┃ ┃ ┃ ┃ ┣ 📂config
 ┃ ┃ ┃ ┃ ┃ ┗ 📜vars.lua
 ┃ ┃ ┃ ┃ ┣ 📂entities
 ┃ ┃ ┃ ┃ ┃ ┗ 📂entities
 ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📂entityfolder
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜init.lua
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜cl_init.lua
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📜shared.lua
 ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📜your_entity_file.lua
 ┃ ┃ ┃ ┃ ┃ ┣ 📂weapons
 ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📂weaponfolder
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜init.lua
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┣ 📜cl_init.lua
 ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📜shared.lua
 ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📜your_weapon_file.lua
 ┃ ┃ ┃ ┃ ┣ 📜cl_anyfile.lua
 ┃ ┃ ┃ ┃ ┗ 📜sh_module.lua
```

As you can see, you can create entities and weapons directly in module folder, base will take care of anything else.

The most important file here is the `sh_module.lua`. Let's check its contents.

#### 📜sh_module.lua
```lua
local MODULE = MODULE
MODULE.systemID = 'custom_id' -- you can select custom id for your module, default id = name of folder that contains this file

MODULE.name = 'my cool module' -- "nice name" of module, will be displayed in modules tab
MODULE.author = 'my cool name' -- name of the author
MODULE.description = 'cool module description' -- description of the module
MODULE.version = 'version' -- version of the module

MODULE.icon = Material('path/to/icon.png') -- path to module icon, I suggest use 128x128 sizes

MODULE.registerAsTable = true -- should register module as table, if true you can access module at any time with `mvp.module_id`

MODULE:IncludeFolder('any_folder') -- adds the folder and all its contents to the module
MODULE:Include('cl_anyfile.lua') -- adds a file to the module

function MODULE:OnLoaded() -- called when module loads
    mvp.utils.Print( self.name, 'loaded!')

    self.playersRespawnTotal = 0 -- you can init some variables here, but remember, this file is shared
end

MODULE:Hook('PlayerSpawn', function(self, ply) -- in this way you can add hooks for modules, self refers to a module
    self.playersRespawnTotal = self.playersRespawnTotal + 1

    mvp.utils.Print( ply:Name(), 'just respawned!')
end)
```

Another important folder is "config", in this folder you can add your files with config options. I suggest use diffrent files for diffrent features of your module, but it can be all in 1 file. As you like. 
#### 📂config/📜vars.lua
```lua
mvp.config.Add('nameOfVariable', 'Default data', 'Description', callbackFunction, {
    category = 'Category', -- you can use MODULE.Name here
    type = 'string' -- diffrent types supported, docs are WIP for now
}, false, false)
```