mvp.ui = mvp.ui or {}
mvp.ui.gradients = {}
local gradientTexture = surface.GetTextureID("gui/gradient")
local whiteMaterial = Material("vgui/white")

function mvp.ui.gradients.DrawGradient(x, y, w, h, r, startColor, endColor)
    local distance = w * .5
    local offsetX = 0
    local offsetY = 0

    if (r ~= 0) then
        local radians = math.rad(r)
        offsetX = distance * math.cos(radians)
        offsetY = distance * math.sin(radians)
    end

    draw.NoTexture()
    surface.SetMaterial(whiteMaterial)
    surface.SetDrawColor(endColor)

    if (r == 0) then
        surface.DrawTexturedRect(x + offsetX, y - offsetY, w, h)
    else
        surface.DrawTexturedRectRotated(x + offsetX, y - offsetY + h * .5, w, h, r)
    end

    surface.SetTexture(gradientTexture)
    surface.SetDrawColor(startColor)

    if (r == 0) then
        surface.DrawTexturedRect(x + offsetX, y - offsetY, w, h)
    else
        surface.DrawTexturedRectRotated(x + offsetX, y - offsetY + h * .5, w, h, r)
    end
end

mvp.ui.gradients.cache = {}

function mvp.ui.gradients.CreateHTMLGradient(id, w, h, rotation, cornerRadius, startColor, endColor, dynamic, manual)
    mvp.ui.gradients.DeleteHTMLGradient(id)
    rotation = rotation or "0deg"
    startColor = startColor or "rgba(32,32,32,1)"
    endColor = endColor or "rgba(51,51,51,1)"
    cornerRadius = cornerRadius or "0px"

    local style = "<style>* {margin: 0; padding: 0} .gradient { width: 100%; height: 100%; border-radius: " .. cornerRadius .. "; background: " .. startColor .. "; background: -moz-linear-gradient(" .. rotation .. ", " .. startColor .. " 0%, " .. endColor .. " 100%); background: -webkit-linear-gradient(" .. rotation .. ", " .. startColor .. " 0%, " .. endColor .. " 100%); background: linear-gradient(" .. rotation .. ", " .. startColor .. " 0%, " .. endColor .. " 100%);" .. "}</style>"

    local html = vgui.Create("DHTML")
    html:SetSize(w, h)
    html:SetVisible(true )
    html:SetHTML(style .. [[
        <div class="gradient"></div>
    ]])

    function html:OnFinishLoadingDocument()
        print("loaded" .. id)
    end

    mvp.ui.gradients.cache[id] = {
        pnl = html
    }

    if (manual) then return id, html end -- let user handle randering of the material

    hook.Add("PreRender", "mvp.gradient." .. id, function()
        if (not IsValid(html)) then
            hook.Remove("PreRender", "mvp.gradient." .. id)

            return
        end

        html:UpdateHTMLTexture()
        local material = html:GetHTMLMaterial()

        if (material) then
            local tw = math.pow(2, math.ceil(math.log(w) / math.log(2))) -- next power of 2 greater than w
            local th = math.pow(2, math.ceil(math.log(h) / math.log(2))) -- next power of 2 greater than h

            local scale_x = w / tw -- scale factor for width
            local scale_y = h / th -- scale factor for height

            print(scale_x, scale_y)

            local matdata = {
                ["$basetexture"] = material:GetName(),
                ["$basetexturetransform"] = "center 0 0 scale " .. scale_x .. " " .. scale_y .. " rotate 0 translate 0 0",
                ["$translucent"] = "1",
                ["$nocull"] = "1",
                ["$nofog"] = "1",
                ["$ignorez"] = "1",
                ["$vertexalpha"] = "1",
                ["$vertexcolor"] = "1"
            }

            -- Create the model material
            mvp.ui.gradients.cache[id].mat = CreateMaterial(id, "UnlitGeneric", matdata)
            print("created html ", id)

            if (not dynamic) then
                PrintTable(mvp.ui.gradients.cache[id].mat:GetColor(400, 400))
                timer.Simple(0.001, function()
                    html:Remove()
                end)
            end
        end
    end)

    return id
end

function mvp.ui.gradients.DrawHTMLGradient(id, x, y, w, h)
    local gradient = mvp.ui.gradients.cache[id]
    if (not gradient) then return end
    local material = gradient.mat
    if (not material) then return end
    -- print("drawing", material:GetName())
    surface.SetMaterial(material)
    surface.SetDrawColor(255, 255, 255)
    surface.DrawTexturedRect(x, y, w, h)
end

function mvp.ui.gradients.DeleteHTMLGradient(id)
    local gradient = mvp.ui.gradients.cache[id]
    if (not gradient) then return end

    if (IsValid(mvp.ui.gradients.cache[id].pnl)) then
        mvp.ui.gradients.cache[id].pnl:Remove()
    end

    mvp.ui.gradients.cache[id] = nil
end