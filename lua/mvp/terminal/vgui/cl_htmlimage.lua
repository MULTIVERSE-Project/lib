--- This is a custom VGUI element that displays an image from a URL with rounded corners using HTML panel.
-- @panel mvp.HTMLImage

local PANEL = {}

--- Sets the image URL.
-- @realm client
-- @function SetImageURL
-- @tparam string url The image URL.

--- Gets the image URL.
-- @realm client
-- @function GetImageURL
-- @treturn string The image URL.
AccessorFunc( PANEL, '_imageUrl', 'ImageURL' )

function PANEL:Init()
    self._image = vgui.Create( 'DHTML', self )
    self._image:Dock( FILL )
    self._image:SetMouseInputEnabled( false )
    self._image:SetKeyboardInputEnabled( false )
    self._image:SetAllowLua( false )
end

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 255))
end

function PANEL:SetImageURL( url )
    self._imageUrl = url
    self._image:SetHTML( [[
        <html>
            <head>
                <style>
                    body {
                        margin: 0;
                        padding: 0;
                        overflow: hidden;
                    }
                    img {
                        width: 100%;
                        height: 100%;
                        object-fit: cover;
                        border-radius: 8px 8px 0 0;
                    }
                </style>
            </head>
            <body>
                <img src="]] .. url .. [[" />
            </body>
        </html>
    ]] )
end

function PANEL:PerformLayout( w, h )
    self._image:SetSize( w, h )

    self._image:QueueJavascript( [[
        var img = document.querySelector( 'img' );
        img.style.width = ']] .. w .. [[px';
        img.style.height = ']] .. h .. [[px';
    ]] )
end

vgui.Register( 'mvp.HTMLImage', PANEL, 'DPanel' )