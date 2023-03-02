--- Default frame with ability to show gradient background.
-- This inherits from [DFrame](https://wiki.facepunch.com/gmod/DFrame) and adds the ability to show a gradient background. All controls over the gradient represented by two functions `SetID` and `GetID`.
-- There currently no ability to change colors of the gradient, but this will be added in the future.
-- @panel mvp.Frame

local PANEL = {}

DEFINE_BASECLASS("DFrame")

--- Sets the ID of the gradient background.
--
-- This is used to delete the gradient when the frame is removed and also to cache the gradient on first creation of the frame.
-- You really want to set this to something unique, otherwise the gradient will be an error texture if panel resizes.
-- @function SetID
-- @realm client
-- @tparam[opt=nil] string id The ID of the gradient. You can set this to nil to have it auto-generated and deleted on removal.

--- Gets the ID of the gradient background
-- @function GetID
-- @realm client
-- @treturn string The ID of the gradient
AccessorFunc(PANEL, "_id", "ID")

function PANEL:Init()
    self:DockPadding(0,0,0,0)
    self.backgroundGradient = mvp.ui.gradients.CreateHTMLGradient("terminalFrame_background_" .. mvp.utils.UUID(4), 800, 600, "135deg", "7px", nil, nil, false )

    self._oldW, self._oldH = self:GetSize()

    print(self._id)
end
function PANEL:PerformLayout(w, h)   
    if (w ~= self._oldW) or (h ~= self._oldH) then -- recreate gradient if resized
        self.backgroundGradient = mvp.ui.gradients.CreateHTMLGradient(self.backgroundGradient, w, h, "135deg", "7px")
        self._oldW, self._oldH = w, h
    end

    BaseClass.PerformLayout(self, w, h)
end

function PANEL:SetID(id)
    if self.backgroundGradient then
        mvp.ui.gradients.DeleteHTMLGradient(self.backgroundGradient)
    end

    self._id = id

    local w, h = self:GetSize()

    self.backgroundGradient = mvp.ui.gradients.CreateHTMLGradient("terminalFrame_background_" .. id, w, h, "135deg", "7px")
end

function PANEL:Paint(w, h)
    draw.RoundedBox(7, 0, 0, w, h, Color(41, 41, 41))

    mvp.ui.gradients.DrawHTMLGradient(self.backgroundGradient, 0, 0, w, h)
end

function PANEL:OnRemove()
    if not self._id then -- remove only auto-generated IDs
        mvp.ui.gradients.DeleteHTMLGradient(self.backgroundGradient)
    end
end

vgui.Register("mvp.Frame", PANEL, "DFrame")