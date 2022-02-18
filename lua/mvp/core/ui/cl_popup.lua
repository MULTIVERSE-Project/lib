mvp = mvp or {}
mvp.utils = mvp.utils or {}

surface.CreateFont('mvp.Popup.Text', {
    font = 'Proxima Nova Rg',
    size = 18,
    extended = true
})

function mvp.utils.Popup(nTime, mIcon, cIconColor, sText)
    if IsValid(mvp.utils.popupFrame) then mvp.utils.popupFrame:OldRemove() end
    
    nTime = nTime or 5
    cIconColor = cIconColor or COLOR_WHITE

    mvp.utils.popupFrame = vgui.Create('DFrame')

    local frame = mvp.utils.popupFrame 
    frame:SetSize(0, 0)
    frame:SetTitle('')
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)

    frame.text = mvp.utils.TextWrap(sText, 'mvp.Popup.Text', 400)

    surface.SetFont('mvp.Popup.Text')
    frame.textSizeX, frame.textSizeY = surface.GetTextSize(frame.text)

    function frame:Create()
        self.drawtext = false
        self.ProgressSize = 0

        local anim = self:NewAnimation(.4, 0, -1, function()
            self:Create2()
        end)
        anim.Size = Vector(500, 80 + self.textSizeY, 0)
        anim.Pos = Vector(ScrW() * .5 - 250, 80, 0)

        anim.Think = function(anim, panel, fraction)
            if ( !anim.StartSize ) then local w, h = panel:GetSize() anim.StartSize = Vector( w, h, 0 ) end
            if ( !anim.StartPos ) then anim.StartPos = Vector( ScrW() * .5, 120, 0 ) end
 
            local size = LerpVector( fraction, anim.StartSize, anim.Size )
            local pos = LerpVector( fraction, anim.StartPos, anim.Pos )
            
            panel:SetSize( size.x, 5 ) 
            panel:SetPos( pos.x, 80 )
        end
    end

    function frame:Create2()
        local anim = self:NewAnimation(.3, 0, -1, function()
            frame.drawtext = true
            self:Remove()
        end)
        anim.Size = Vector(500, 60 + self.textSizeY, 0)
        anim.Pos = Vector(ScrW() * .5 - 250, 40, 0)

        anim.Think = function(anim, panel, fraction)
            if ( !anim.StartSize ) then local w, h = panel:GetSize() anim.StartSize = Vector( w, h, 0 ) end
            if ( !anim.StartPos ) then local w, h = panel:GetPos() anim.StartPos = Vector( w, h, 0 ) end
 
            local size = LerpVector( fraction, anim.StartSize, anim.Size )
            local pos = LerpVector( fraction, anim.StartPos, anim.Pos )
            
            panel:SetSize( 500, size.y ) 
            panel:SetPos( ScrW() * .5 - 250, pos.y )

            panel.textalpha = Lerp(fraction * .6, panel.textalpha or 0, 255)
        end

        local anim2 = self:NewAnimation(nTime, 0, -1, function()
            
        end)

        anim2.Size = 500
        anim2.Think = function(anim, panel, fraction)
            if ( !anim.StartSize ) then anim.StartSize = 0 end
 
            local size = Lerp(fraction, anim.StartSize, anim.Size)
            
            panel.ProgressSize = size
        end
    end

    frame.OldRemove = frame.Remove
    function frame:Remove()        
        local anim = self:NewAnimation(.4, nTime, -1, function()
            frame.drawtext = false
            frame:Remove2()
        end)
        self.ProgressSize = 0
        anim.Size = Vector(self:GetWide(), 5, 0)
        anim.Pos = Vector(ScrW() * .5 - 250, 120, 0)

        anim.Think = function(anim, panel, fraction)
            if ( !anim.StartSize ) then local w, h = panel:GetSize() anim.StartSize = Vector( w, h, 0 ) end
            if ( !anim.StartPos ) then local w, h = panel:GetPos() anim.StartPos = Vector( w, h, 0 ) end
 
            local size = LerpVector( fraction, anim.StartSize, anim.Size )
            local pos = LerpVector( fraction, anim.StartPos, anim.Pos )
            
            panel:SetSize( size.x, size.y ) 
            panel:SetPos( pos.x, pos.y )

            panel.textalpha = Lerp(fraction, panel.textalpha or 0, 0)
        end
    end
    function frame:Remove2()        
        local anim = self:NewAnimation(.3, .2, -1, function()
            frame:OldRemove()
        end)
        
        anim.Size = Vector(0, 5, 0)
        anim.Pos = Vector(ScrW() * .5, 120, 0)

        anim.Think = function(anim, panel, fraction)
            if ( !anim.StartSize ) then local w, h = panel:GetSize() anim.StartSize = Vector( w, h, 0 ) end
            if ( !anim.StartPos ) then local w, h = panel:GetPos() anim.StartPos = Vector( w, h, 0 ) end
 
            local size = LerpVector( fraction, anim.StartSize, anim.Size )
            local pos = LerpVector( fraction, anim.StartPos, anim.Pos )
            
            panel:SetSize( size.x, size.y ) 
            panel:SetPos( pos.x, pos.y )
        end
    end

    function frame:Paint(w, h)        
        surface.SetDrawColor(Color(40, 40, 40, 150))
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(COLOR_GREEN)
        surface.DrawRect(0, h - 7, self.ProgressSize, 3)

        surface.SetDrawColor(Color(70, 70, 70))
        surface.DrawRect(0, 0, w, 5)
        surface.DrawRect(0, h - 5, w, 5)

        frame:DrawIcon(w, h)

        draw.DrawText(self.text, 'mvp.Popup.Text', 84 - (mIcon and 0 or 64), h * .5 - self.textSizeY * .5, ColorAlpha(color_white, self.textalpha or 0))
    end

    function frame:DrawIcon(w, h)
        if not mIcon then return end
        surface.SetDrawColor(ColorAlpha(cIconColor, self.textalpha or 0))
        surface.SetMaterial(mIcon)

        surface.DrawTexturedRect(10, h * .5 - 32, 64, 64)
    end

    frame:Create()
    return frame
end

-- concommand.Add('mvp_popup_debug', function()
--     mvp.utils.Popup(5, nil, COLOR_WHITE, 'This is debug on-screen popup')
-- end)