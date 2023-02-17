local gradientTexture = surface.GetTextureID("gui/gradient")

function mvp.TerminalMenu()
    local frame = vgui.Create("mvp.Frame")
    frame:SetSize(mvp.ui.Scale(1600), mvp.ui.Scale(800))
    frame:Center()
    frame:MakePopup()
    frame:ShowCloseButton(false)
    local sidebar = vgui.Create("EditablePanel", frame)
    sidebar:Dock(LEFT)
    sidebar:SetWide(mvp.ui.Scale(270))
    sidebar:DockPadding(0, 65, mvp.ui.Scale(5), 0)

    function sidebar:Paint(w, h)
        draw.RoundedBoxEx(7, 0, 0, mvp.ui.Scale(65), h, Color(51, 51, 51), true, false, true, false)
        draw.RoundedBox(0, w - mvp.ui.Scale(5), 0, mvp.ui.Scale(5), h, Color(51, 51, 51))
    end

    local testButton = vgui.Create("DButton", sidebar)
    testButton:Dock(TOP)
    testButton:SetTall(mvp.ui.Scale(50))
    testButton.rect = 0

    function testButton:Paint(w, h)
        if (self:IsHovered()) then
            self.rect = Lerp(FrameTime() * 10, self.rect, w - mvp.ui.Scale(65) + 10)
        else
            self.rect = Lerp(FrameTime() * 10, self.rect, 0)
        end

        mvp.ui.gradients.DrawGradient(0, 0, mvp.ui.Scale(65), h, 0, Color(244, 144, 12), Color(255, 192, 92))
        mvp.ui.DrawIcon(mvp.ui.Scale(65) * .5, h * .5, "f015", mvp.ui.Scale(32), color_white)
        draw.NoTexture()
        surface.SetTexture(gradientTexture)
        surface.SetDrawColor(Color(255, 193, 92, 15))
        surface.DrawTexturedRect(mvp.ui.Scale(65) - 10, 0, self.rect, h)

        return true
    end

    local testButton = vgui.Create("DButton", sidebar)
    testButton:Dock(TOP)
    testButton:SetTall(mvp.ui.Scale(50))
    testButton.rect = 0
    testButton.mult = 0

    function testButton:Paint(w, h)
        if (self:IsHovered()) then
            self.rect = Lerp(FrameTime() * 10, self.rect, w - mvp.ui.Scale(65))
            self.mult = Lerp(FrameTime() * 10, self.mult, 1)
        else
            self.rect = Lerp(FrameTime() * 10, self.rect, 0)
            self.mult = Lerp(FrameTime() * 10, self.mult, 0)
        end

        surface.SetAlphaMultiplier(self.mult)
        mvp.ui.gradients.DrawGradient(0, 0, mvp.ui.Scale(65), h, 0, Color(74, 74, 74), Color(62, 62, 62))
        surface.SetAlphaMultiplier(1)
        mvp.ui.DrawIcon(mvp.ui.Scale(65) * .5, h * .5, "f013", mvp.ui.Scale(32), color_white)
        surface.SetAlphaMultiplier(self.mult)
        draw.NoTexture()
        surface.SetTexture(gradientTexture)
        surface.SetDrawColor(Color(62, 62, 62, 100))
        surface.DrawTexturedRect(mvp.ui.Scale(65), 0, self.rect, h)

        return true
    end

    local testButton = vgui.Create("DButton", sidebar)
    testButton:Dock(TOP)
    testButton:SetTall(mvp.ui.Scale(50))
    testButton.rect = 0
    testButton.mult = 0

    function testButton:Paint(w, h)
        if (self:IsHovered()) then
            self.rect = Lerp(FrameTime() * 10, self.rect, w - mvp.ui.Scale(65))
            self.mult = Lerp(FrameTime() * 10, self.mult, 1)
        else
            self.rect = Lerp(FrameTime() * 10, self.rect, 0)
            self.mult = Lerp(FrameTime() * 10, self.mult, 0)
        end

        surface.SetAlphaMultiplier(self.mult)
        mvp.ui.gradients.DrawGradient(0, 0, mvp.ui.Scale(65), h, 0, Color(74, 74, 74), Color(62, 62, 62))
        surface.SetAlphaMultiplier(1)
        mvp.ui.DrawIcon(mvp.ui.Scale(65) * .5, h * .5, "f03a", mvp.ui.Scale(32), color_white)
        surface.SetAlphaMultiplier(self.mult)
        draw.NoTexture()
        surface.SetTexture(gradientTexture)
        surface.SetDrawColor(Color(62, 62, 62, 100))
        surface.DrawTexturedRect(mvp.ui.Scale(65), 0, self.rect, h)

        return true
    end

    local testButton = vgui.Create("DButton", sidebar)
    testButton:Dock(BOTTOM)
    testButton:SetTall(mvp.ui.Scale(50))
    testButton.rect = 0
    testButton.mult = 0
    local mask = BMASKS.CreateMask("closeButton", "mvp_terminal_ui/close_rounded.png", "smooth")

    function testButton:Paint(w, h)
        if (self:IsHovered()) then
            self.rect = Lerp(FrameTime() * 10, self.rect, w - mvp.ui.Scale(65))
            self.mult = Lerp(FrameTime() * 10, self.mult, 1)
        else
            self.rect = Lerp(FrameTime() * 10, self.rect, 0)
            self.mult = Lerp(FrameTime() * 10, self.mult, 0)
        end

        BMASKS.BeginMask(mask)
        surface.SetAlphaMultiplier(self.mult)
        mvp.ui.gradients.DrawGradient(0, 0, mvp.ui.Scale(65), h, 0, Color(255, 68, 68), Color(176, 42, 42))
        -- surface.SetDrawColor(Color(255, 255, 255))
        -- surface.DrawRect(0, 0, w, h)
        BMASKS.EndMask(mask, 0, 0, mvp.ui.Scale(65), h)
        surface.SetAlphaMultiplier(1)
        mvp.ui.DrawIcon(mvp.ui.Scale(65) * .5 - 1, h * .5, "f00d", mvp.ui.Scale(32), color_white)
        surface.SetAlphaMultiplier(self.mult)
        draw.NoTexture()
        surface.SetTexture(gradientTexture)
        surface.SetDrawColor(Color(255, 68, 68, 15))
        surface.DrawTexturedRect(mvp.ui.Scale(65), 0, self.rect, h)

        return true
    end

    function testButton:DoClick()
        frame:Remove()
    end

    local frames = {
        ["btn_left_128"] = {
            frame = {
                x = 273,
                y = 1,
                w = 128,
                h = 128
            },
            spriteSourceSize = {
                x = 0,
                y = 0,
                w = 128,
                h = 128
            },
            sourceSize = {
                w = 128,
                h = 128
            }
        },
        ["btn_right_128"] = {
            frame = {
                x = 273,
                y = 131,
                w = 128,
                h = 128
            },
            spriteSourceSize = {
                x = 0,
                y = 0,
                w = 128,
                h = 128
            },
            sourceSize = {
                w = 128,
                h = 128
            }
        },
        ["btn_left_64"] = {
            frame = {
                x = 1,
                y = 286,
                w = 64,
                h = 64
            },
            spriteSourceSize = {
                x = 0,
                y = 0,
                w = 64,
                h = 64
            },
            sourceSize = {
                w = 64,
                h = 64
            }
        },
        ["btn_right_64"] = {
            frame = {
                x = 67,
                y = 286,
                w = 64,
                h = 64
            },
            spriteSourceSize = {
                x = 0,
                y = 0,
                w = 64,
                h = 64
            },
            sourceSize = {
                w = 64,
                h = 64
            }
        },
        ["btn_left_32"] = {
            frame = {
                x = 133,
                y = 286,
                w = 32,
                h = 32
            },
            spriteSourceSize = {
                x = 0,
                y = 0,
                w = 32,
                h = 32
            },
            sourceSize = {
                w = 32,
                h = 32
            }
        },
        ["btn_right_32"] = {
            frame = {
                x = 167,
                y = 286,
                w = 32,
                h = 32
            },
            spriteSourceSize = {
                x = 0,
                y = 0,
                w = 32,
                h = 32
            },
            sourceSize = {
                w = 32,
                h = 32
            }
        },
        ["btn_left_16"] = {
            frame = {
                x = 133,
                y = 320,
                w = 16,
                h = 16
            },
            spriteSourceSize = {
                x = 0,
                y = 0,
                w = 16,
                h = 16
            },
            sourceSize = {
                w = 16,
                h = 16
            }
        },
        ["btn_right_16"] = {
            frame = {
                x = 151,
                y = 320,
                w = 16,
                h = 16
            },
            spriteSourceSize = {
                x = 0,
                y = 0,
                w = 16,
                h = 16
            },
            sourceSize = {
                w = 16,
                h = 16
            }
        },
        ["btn_left_8"] = {
            frame = {
                x = 133,
                y = 338,
                w = 8,
                h = 8
            },
            spriteSourceSize = {
                x = 0,
                y = 0,
                w = 8,
                h = 8
            },
            sourceSize = {
                w = 8,
                h = 8
            }
        },
        ["btn_right_8"] = {
            frame = {
                x = 143,
                y = 338,
                w = 8,
                h = 8
            },
            spriteSourceSize = {
                x = 0,
                y = 0,
                w = 8,
                h = 8
            },
            sourceSize = {
                w = 8,
                h = 8
            }
        }
    }

    local function getUV(name)
        return frames[name].frame
    end

    local btn = vgui.Create("DButton", frame)
    btn:SetSize(144, 30)
    btn:SetPos(300, 40)

    function btn:Paint(w, h)
      draw.RoundedBoxEx(8, w * .5, 0, w * .5, h, Color(176, 42, 42), false, true, false, true)
      draw.RoundedBoxEx(8, 0, 0, w * .5, h, Color(255, 68, 68), true, false, true, false)
      mvp.ui.gradients.DrawGradient(8, 0, w - 16, h, 0, Color(255, 68, 68), Color(176, 42, 42))

      mvp.ui.DrawPolyMask(function()
        mvp.ui.DrawRoundedBox(6, 1, 1, w - 2, h - 2)
      end, function()
        mvp.ui.gradients.DrawGradient(0, 0, w, h, 0, Color(255, 68, 68), Color(176, 42, 42))
      end)
    end
end