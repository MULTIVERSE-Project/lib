<a name="readme-top"></a>

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->

<div align="center">

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

</div>

<!-- PROJECT LOGO -->
<br />
<div align="center">

  <img src="/images/mvp_base_glyph.png" width="256" height="256"/>

  <h3 align="center" style="margin-bottom: 0;">MULTIVERSE Project Library</h3>
  <sup>( MVPL )</sup>
  <p align="center">
    Open-source library for GMod servers that capible of easy in-game config integrations, modern UI and modules.
    <br />
    <br />
    <a href="https://github.com/MULTIVERSE-Project/lib/issues">Report Bug</a>
    ·
    <a href="https://github.com/MULTIVERSE-Project/lib/issues">Request Feature</a>
  </p>
</div>

<!-- ABOUT THE PROJECT -->

## About The Project

This is our library to help you quickly develop addons for your servers. We have built many features into this library. Starting with in-game config, to the ability to use FontAwesome icons.

<!-- GETTING STARTED -->

## Getting Started

* Subscribe to addon on the steam workshop page.
* Start/restart your server.
* Base will do all necessary things by itself.

### Configurating

* Type `!mvp` in chat.
* Select in left sidebar "Config" option.
* You should see all avaible config options for base and instaled modules.

<!-- USAGE EXAMPLES -->

## Usage

Our base provides a tons of functionality. You can create your own modules using our API and docs.

Let's create a simple connect/disconnect chat notifier.

Firs of all, create your module folder in `addons/<your_addon_folder>/mvp/modules/<your_module_folder>/` in that folder you should put `sh_module.lua` file, it's serves as entry point for our brand new module.

:page_facing_up: Contents of: `sh_module.lua`
```lua
local MODULE = MODULE

--[[
  Module details
]]--
MODULE:SetName('Join/Leave messages') -- Module "fancy" title
MODULE:SetDescription('Sends a chat message when someone leaves or joins.') -- Module description
MODULE:SetAuthor('Myself') -- Module author
MODULE:SetVersion('1.0.0') -- Module version

gameevent.Listen('player_connect') -- Otherwise we will not recieve hooks about player connect
-- Creating a hook, this can be treated as hook.Add(...), but for modules.
MODULE:Hook('player_connect', function(self, data)
--                               MODULE^     ^ Hook variables
  for i, ply in ipairs( player.GetAll() ) do
		ply:ChatPrint( data.name .. ' has connected to server!' )
	end
end)

gameevent.Listen('player_disconnect')
MODULE:Hook('player_disconnect', function(self, data)
  for i, ply in ipairs( player.GetAll() ) do
		ply:ChatPrint( data.name .. ' disconnected!' )
	end
end)
```

_For more examples, please refer to the [Documentation](https://docs.multiverse-project.com/lib/)_

<!-- ROADMAP -->

## Roadmap

- [x] In-game config
- [ ] Modules system
  - [x] Entities-per-module
  - [x] Config per module
  - [x] Ability to disable modules
  - [ ] Modules dependencies
- [x] Complete UI set
  - [x] Buttons
  - [x] Categories
  - [x] Text inputs
  - [x] Frames
  - [x] Pop-ups
  - [x] Modal windows
- [x] Font Manager
  - [x] Font Awesome integration
- [x] Themes Manager
  - [ ] In-game theme editor (maybe)


See the [open issues](https://github.com/MULTIVERSE-Project/lib/issues) for a full list of proposed features (and known issues).

<!-- CONTRIBUTING -->

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!-- LICENSE -->

## License

Distributed under the MPL-2.0 license. See `LICENSE` for more information.

<!-- ACKNOWLEDGMENTS -->

<!-- 
## Acknowledgments

- []()
- []()
- []() -->

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-shield]: https://img.shields.io/github/contributors/MULTIVERSE-Project/lib.svg?style=for-the-badge
[contributors-url]: https://github.com/MULTIVERSE-Project/lib/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/MULTIVERSE-Project/lib.svg?style=for-the-badge
[forks-url]: https://github.com/MULTIVERSE-Project/lib/network/members
[stars-shield]: https://img.shields.io/github/stars/MULTIVERSE-Project/lib.svg?style=for-the-badge
[stars-url]: https://github.com/MULTIVERSE-Project/lib/stargazers
[issues-shield]: https://img.shields.io/github/issues/MULTIVERSE-Project/lib.svg?style=for-the-badge
[issues-url]: https://github.com/MULTIVERSE-Project/lib/issues
[license-shield]: https://img.shields.io/github/license/MULTIVERSE-Project/lib.svg?style=for-the-badge
[license-url]: https://github.com/MULTIVERSE-Project/lib/blob/main/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
