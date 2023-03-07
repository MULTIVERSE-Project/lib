--- @module mvp.ui.gradients

mvp.ui = mvp.ui or {}
mvp.ui.gradients = {}
local gradientTexture = surface.GetTextureID("gui/gradient")
local whiteMaterial = Material("vgui/white")

--- Draws a gradient
-- @realm client
-- @tparam number x The x position
-- @tparam number y The y position
-- @tparam number w The width
-- @tparam number h The height
-- @tparam number r The rotation
-- @tparam Color startColor The start color
-- @tparam Color endColor The end color
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

--- Creates a gradient material from HTML
-- @realm client
-- @tparam string id The id of the gradient for caching purposes
-- @tparam number w The width
-- @tparam number h The height
-- @tparam string rotation The rotation
-- @tparam string cornerRadius The corner radius
-- @tparam string startColor The start color
-- @tparam string endColor The end color
-- @tparam boolean ignoreCache Whether to ignore the cache
-- @tparam boolean manual Whether to return the HTML panel
-- @treturn string The id of the gradient
-- @usage
-- local gradient = mvp.ui.gradients.CreateHTMLGradient("test", 100, 100, "0deg", "0px", "rgba(32,32,32,1)", "rgba(51,51,51,1)")
-- mvp.ui.gradients.DrawHTMLGradient(gradient, 0, 0, 100, 100)
-- @see mvp.ui.gradients.DrawHTMLGradient
function mvp.ui.gradients.CreateHTMLGradient(id, w, h, rotation, cornerRadius, startColor, endColor, ignoreCache, manual)
    if (not ignoreCache and mvp.ui.gradients.cache[id]) then
        return id
    end
    
    mvp.ui.gradients.DeleteHTMLGradient(id)

    rotation = rotation or "0deg"
    startColor = startColor or "rgba(32,32,32,1)"
    endColor = endColor or "rgba(51,51,51,1)"
    cornerRadius = cornerRadius or "0px"

    local style = "<style>* {margin: 0; padding: 0} .gradient { width: 100%; height: 100%; border-radius: " .. cornerRadius .. "; background: " .. startColor .. "; background: -moz-linear-gradient(" .. rotation .. ", " .. startColor .. " 0%, " .. endColor .. " 100%); background: -webkit-linear-gradient(" .. rotation .. ", " .. startColor .. " 0%, " .. endColor .. " 100%); background: linear-gradient(" .. rotation .. ", " .. startColor .. " 0%, " .. endColor .. " 100%);" .. "}</style>"

    local html = vgui.Create("DHTML")
    html:SetSize(w, h)
    html:SetVisible(false)
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

            mvp.ui.gradients.cache[id].mat = CreateMaterial(id, "UnlitGeneric", matdata)

            timer.Simple(5, function() -- janky solution, but it works
                html:Remove()
            end)
        end
    end)

    return id
end

--- Draws a gradient material from HTML
-- @realm client
-- @tparam string id The id of the gradient
-- @tparam number x The x position
-- @tparam number y The y position
-- @tparam number w The width
-- @tparam number h The height
-- @usage
-- local gradient = mvp.ui.gradients.CreateHTMLGradient("test", 100, 100, "0deg", "0px", "rgba(32,32,32,1)", "rgba(51,51,51,1)")
-- mvp.ui.gradients.DrawHTMLGradient(gradient, 0, 0, 100, 100)
-- @see mvp.ui.gradients.CreateHTMLGradient
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

--- Deletes a gradient material from HTML
-- @realm client
-- @tparam string id The id of the gradient
-- @usage
-- mvp.ui.gradients.DeleteHTMLGradient("test")
-- @see mvp.ui.gradients.CreateHTMLGradient
function mvp.ui.gradients.DeleteHTMLGradient(id)
    local gradient = mvp.ui.gradients.cache[id]
    if (not gradient) then return end

    if (IsValid(mvp.ui.gradients.cache[id].pnl)) then
        mvp.ui.gradients.cache[id].pnl:Remove()
    end

    mvp.ui.gradients.cache[id] = nil
end