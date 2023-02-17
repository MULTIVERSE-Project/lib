--This code can be improved a lot.
--Feel free to improve, use or modify in any way although credit would be appreciated.
if BMASKS == nil then
    BMASKS = {} --Global table, access the functions here
    BMASKS.Materials = {} --Cache materials so they dont need to be reloaded
    BMASKS.Masks = {} --A table of all active mask objects, you should destroy a mask object when done with it

    --The material used to draw the render targets
    BMASKS.MaskMaterial = CreateMaterial("!bluemask", "UnlitGeneric", {
        ["$translucent"] = 1,
        ["$vertexalpha"] = 1,
        ["$alpha"] = 1
    })

    --Creates a mask with the specified options
    --Be sure to pass a unique maskName for each mask, otherwise they will override each other
    BMASKS.CreateMask = function(maskName, maskPath, maskProperties)
        local mask = {}
        --Set mask name
        mask.name = maskName

        --Load materials
        if BMASKS.Materials[maskPath] == nil then
            BMASKS.Materials[maskPath] = Material(maskPath, maskProperties)
        end

        --Set the mask material
        mask.material = BMASKS.Materials[maskPath]
        --Create the render target
        mask.renderTarget = GetRenderTargetEx("BMASKS:" .. maskName, ScrW(), ScrH(), RT_SIZE_FULL_FRAME_BUFFER, MATERIAL_RT_DEPTH_NONE, 2, CREATERENDERTARGETFLAGS_UNFILTERABLE_OK, IMAGE_FORMAT_RGBA8888)
        BMASKS.Masks[maskName] = mask

        return maskName
    end

    --Call this to begin drawing with a mask.
    --After calling this any draw call will be masked until you call EndMask(maskName)
    BMASKS.BeginMask = function(maskName)
        --FindMask
        if BMASKS.Masks[maskName] == nil then
            print("Cannot begin a mask without creating it first!")

            return false
        end

        --Store current render target
        BMASKS.Masks[maskName].previousRenderTarget = render.GetRenderTarget()
        --Confirgure drawing so that we write to the masks render target
        render.PushRenderTarget(BMASKS.Masks[maskName].renderTarget)
        render.OverrideAlphaWriteEnable(true, true)
        render.Clear(0, 0, 0, 0)
    end

    --Ends the mask and draws it
    --Not calling this after calling BeginMask will cause some really bad effects 
    --This done return the render target used, using this you can create other effects such as drop shadows without problems
    --Passes true for dontDraw will result in it not being render and only returning the texture of the result (which is ScrW()xScrH())
    BMASKS.EndMask = function(maskName, x, y, sizex, sizey, opacity, rotation, dontDraw)
        dontDraw = dontDraw or false
        rotation = rotation or 0
        opacity = opacity or 255
        --Draw the mask
        render.OverrideBlendFunc(true, BLEND_ZERO, BLEND_SRC_ALPHA, BLEND_DST_ALPHA, BLEND_ZERO)
        surface.SetDrawColor(Color(255, 255, 255, opacity))
        surface.SetMaterial(BMASKS.Masks[maskName].material)

        if rotation == nil or rotation == 0 then
            surface.DrawTexturedRect(x, y, sizex, sizey)
        else
            surface.DrawTexturedRectRotated(x, y, sizex, sizey, rotation)
        end

        render.OverrideBlendFunc(false)
        render.OverrideAlphaWriteEnable(false)
        render.PopRenderTarget()
        --Update material
        BMASKS.MaskMaterial:SetTexture('$basetexture', BMASKS.Masks[maskName].renderTarget)
        --Clear material for upcoming draw calls
        draw.NoTexture()

        --Only draw if they want is to
        if not dontDraw then
            --Now draw finished result
            surface.SetDrawColor(Color(255, 255, 255, 255))
            surface.SetMaterial(BMASKS.MaskMaterial)
            render.SetMaterial(BMASKS.MaskMaterial)
            render.DrawScreenQuad()
        end

        return BMASKS.Masks[maskName].renderTarget
    end

	BMASKS.EndMaskUV = function(maskName, x, y, sizex, sizey, u0, v0, u1, v1, atlasSize, opacity)
        opacity = opacity or 255

        --Draw the mask
        render.OverrideBlendFunc(true, BLEND_ZERO, BLEND_SRC_ALPHA, BLEND_DST_ALPHA, BLEND_ZERO)
        surface.SetDrawColor(Color(255, 255, 255, opacity))
        surface.SetMaterial(BMASKS.Masks[maskName].material)

        surface.DrawTexturedRectUV(x, y, sizex, sizey, u0, v0, u1, v1)

        render.OverrideBlendFunc(false)
        render.OverrideAlphaWriteEnable(false)
        render.PopRenderTarget()
        --Update material
        BMASKS.MaskMaterial:SetTexture('$basetexture', BMASKS.Masks[maskName].renderTarget)
        --Clear material for upcoming draw calls
        draw.NoTexture()

        surface.SetDrawColor(Color(255, 255, 255, 255))
        surface.SetMaterial(BMASKS.MaskMaterial)
        render.SetMaterial(BMASKS.MaskMaterial)
        render.DrawScreenQuad()

        return BMASKS.Masks[maskName].renderTarget
    end
end