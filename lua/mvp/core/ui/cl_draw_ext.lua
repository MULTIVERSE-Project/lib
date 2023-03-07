--- @module mvp.ui
mvp.ui = mvp.ui or {}

do
    local cosCache = {}
    local sinCache = {}

    local math_cos = function(value)
        if (cosCache[value]) then return cosCache[value] end
        cosCache[value] = math.cos(math.rad(value))

        return cosCache[value]
    end

    local math_sin = function(value)
        if (sinCache[value]) then return sinCache[value] end
        sinCache[value] = math.sin(math.rad(value))

        return sinCache[value]
    end

    --- Draws a rounded box
    -- @realm client
    -- @tparam number cornerRadius The radius of the corners
    -- @tparam number x The x position of the box
    -- @tparam number y The y position of the box
    -- @tparam number w The width of the box
    -- @tparam number h The height of the box
    -- @tparam boolean noDraw Whether to draw the box or not
    -- @treturn table The polygon table
    function mvp.ui.DrawRoundedBox(cornerRadius, x, y, w, h, noDraw)
        local poly = {}

        poly[1] = {
            x = x + w / 2,
            y = y + h / 2,
            u = 0.5,
            v = 0.5
        }

        poly[2] = {
            x = x + w / 2,
            y = y,
            u = 0.5,
            v = 0
        }

        poly[3] = {
            x = x + w - cornerRadius,
            y = y,
            u = (w - cornerRadius) / w,
            v = 0
        }

        local topX = x + w - cornerRadius
        local topY = y + cornerRadius

        for i = -89, 0 do
            local X = topX + math_cos(i) * cornerRadius
            local Y = topY + math_sin(i) * cornerRadius

            poly[#poly + 1] = {
                x = X,
                y = Y,
                u = (X - x) / w,
                v = (Y - y) / h
            }
        end

        poly[#poly + 1] = {
            x = x + w,
            y = y + h - cornerRadius,
            u = 1,
            v = (h - cornerRadius) / h
        }

        topX = x + w - cornerRadius
        topY = y + h - cornerRadius

        for i = 1, 90 do
            local X = topX + math_cos(i) * cornerRadius
            local Y = topY + math_sin(i) * cornerRadius

            poly[#poly + 1] = {
                x = X,
                y = Y,
                u = (X - x) / w,
                v = (Y - y) / h
            }
        end

        poly[#poly + 1] = {
            x = x + cornerRadius,
            y = y + h,
            u = cornerRadius / w,
            v = 1
        }

        topX = x + cornerRadius
        topY = y + h - cornerRadius

        for _i = 180, 270 do
            i = _i - 90
            local X = topX + math_cos(i) * cornerRadius
            local Y = topY + math_sin(i) * cornerRadius

            poly[#poly + 1] = {
                x = X,
                y = Y,
                u = (X - x) / w,
                v = (Y - y) / h
            }
        end

        poly[#poly + 1] = {
            x = x,
            y = y + cornerRadius,
            u = 0,
            v = cornerRadius / h
        }

        topX = x + cornerRadius
        topY = y + cornerRadius

        for _i = 270, 360 do
            i = _i - 90
            local X = topX + math_cos(i) * cornerRadius
            local Y = topY + math_sin(i) * cornerRadius

            poly[#poly + 1] = {
                x = X,
                y = Y,
                u = (X - x) / w,
                v = (Y - y) / h
            }
        end

        poly[#poly + 1] = {
            x = x + w / 2,
            y = y,
            u = 0.5,
            v = 0
        }

        if not noDraw then
            surface.DrawPoly(poly)
        end

        return poly
    end

    --- Draws a rounded box with a gradient
    -- @realm client
    -- @tparam number cornerRadius The radius of the corners
    -- @tparam number x The x position of the box
    -- @tparam number y The y position of the box
    -- @tparam number w The width of the box
    -- @tparam number h The height of the box
    -- @tparam Color startColor The start color of the gradient
    -- @tparam Color endColor The end color of the gradient
    function mvp.ui.DrawRoundedBoxGradient(cornerRadius, x, y, w, h, startColor, endColor)
        draw.RoundedBoxEx(cornerRadius, w - cornerRadius * 2, 0, cornerRadius * 2, h, endColor, false, true, false, true)
        draw.RoundedBoxEx(cornerRadius, 0, 0, cornerRadius * 2, h, startColor, true, false, true, false)

        mvp.ui.gradients.DrawGradient(cornerRadius, 0, w - cornerRadius * 2, h, 0, startColor, endColor)
    end
end

do 
    --- Draws a circle
    -- @realm client
    -- @tparam number x The x position of the circle
    -- @tparam number y The y position of the circle
    -- @tparam number r The radius of the circle
    -- @tparam number step The step of the circle
    -- @tparam boolean cache Whether to cache the circle or not
    -- @treturn[1] table The circle table
    -- @treturn[2] nil
	function mvp.ui.DrawCircle(x, y, r, step, cache)
		local positions = {}
	
		for i = 0, 360, step do
			table.insert(positions, {
				x = x + math.cos(math.rad(i)) * r,
				y = y + math.sin(math.rad(i)) * r
			})
		end
	
		return (cache and positions) or surface.DrawPoly(positions)
	end
	
    --- Draws an arc
    -- @realm client
    -- @tparam number x The x position of the arc
    -- @tparam number y The y position of the arc
    -- @tparam number r The radius of the arc
    -- @tparam number startAng The start angle of the arc
    -- @tparam number endAng The end angle of the arc
    -- @tparam number step The step of the arc
    -- @tparam boolean cache Whether to cache the arc or not
    -- @treturn[1] table The arc table
    -- @treturn[2] nil
	function mvp.ui.DrawArc(x, y, r, startAng, endAng, step, cache)
		local positions = {}
	
		positions[1] = {
			x = x,
			y = y
		}
	
		for i = startAng - 90, endAng - 90, step do
			table.insert(positions, {
				x = x + math.cos(math.rad(i)) * r,
				y = y + math.sin(math.rad(i)) * r
			})
		end
	
		return (cache and positions) or surface.DrawPoly(positions)
	end
	
    --- Draws a pie
    -- @realm client
    -- @tparam number cx The center x position of the pie
    -- @tparam number cy The center y position of the pie
    -- @tparam number radius The radius of the pie
    -- @tparam number thickness The thickness of the pie
    -- @tparam number startang The start angle of the pie
    -- @tparam number endang The end angle of the pie
    -- @tparam number roughness The roughness of the pie
    -- @tparam boolean cache Whether to cache the pie or not
    -- @treturn[1] table The pie table
    -- @treturn[2] nil
	function mvp.ui.DrawSubSection(cx, cy, radius, thickness, startang, endang, roughness, cache)
		local triarc = {}
		-- local deg2rad = math.pi / 180
		-- Define step
		local roughness = math.max(roughness or 1, 1)
		local step = roughness
		-- Correct start/end ang
		local startang, endang = startang or 0, endang or 0
	
		if startang > endang then
			step = math.abs(step) * -1
		end
	
		-- Create the inner circle's points.
		local inner = {}
		local r = radius - thickness
	
		for deg = startang, endang, step do
			local rad = math.rad(deg)
			-- local rad = deg2rad * deg
			local ox, oy = cx + (math.cos(rad) * r), cy + (-math.sin(rad) * r)
	
			table.insert(inner, {
				x = ox,
				y = oy,
				u = (ox - cx) / radius + .5,
				v = (oy - cy) / radius + .5
			})
		end
	
		-- Create the outer circle's points.
		local outer = {}
	
		for deg = startang, endang, step do
			local rad = math.rad(deg)
			-- local rad = deg2rad * deg
			local ox, oy = cx + (math.cos(rad) * radius), cy + (-math.sin(rad) * radius)
	
			table.insert(outer, {
				x = ox,
				y = oy,
				u = (ox - cx) / radius + .5,
				v = (oy - cy) / radius + .5
			})
		end
	
		-- Triangulize the points.
		-- twice as many triangles as there are degrees.
		for tri = 1, #inner * 2 do
			local p1, p2, p3
			p1 = outer[math.floor(tri / 2) + 1]
			p3 = inner[math.floor((tri + 1) / 2) + 1]
	
			--if the number is even use outer.
			if tri % 2 == 0 then
				p2 = outer[math.floor((tri + 1) / 2)]
			else
				p2 = inner[math.floor((tri + 1) / 2)]
			end
	
			table.insert(triarc, {p1, p2, p3})
		end
	
		if cache then
			return triarc
		else
			for k, v in pairs(triarc) do
				surface.DrawPoly(v)
			end
		end
	end
end

do
    --- Draws a polygon mask
    -- @realm client
    -- @tparam function mask The mask function
    -- @tparam function content The content function
    -- @usage mvp.ui.DrawPolyMask(function()
    --     mvp.ui.DrawCircle(ScrW() / 2, ScrH() / 2, 100, 1)
    -- end, function()
    --     draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(255, 0, 0))
    -- end)
    function mvp.ui.DrawPolyMask(mask, content)
        render.ClearStencil()
		render.SetStencilEnable(true)

		render.SetStencilWriteMask(1)
		render.SetStencilTestMask(1)

		render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
		render.SetStencilPassOperation(STENCILOPERATION_ZERO)
		render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
		render.SetStencilReferenceValue(1)

		draw.NoTexture()
		surface.SetDrawColor(255, 255, 255, 255)

        mask()

        render.SetStencilFailOperation(STENCILOPERATION_ZERO)
		render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
		render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
		render.SetStencilReferenceValue(1)
        
        content()
        
        render.SetStencilEnable(false)
        render.ClearStencil()
    end
end

do
    --- Draws a dual text
    -- @realm client
    -- @tparam number x The x position
    -- @tparam number y The y position
    -- @tparam string topText The top text
    -- @tparam[opt] mvp.Font topFont The top font
    -- @tparam[opt] Color topColor The top color
    -- @tparam string bottomText The bottom text
    -- @tparam[opt] mvp.Font bottomFont The bottom font
    -- @tparam[opt] Color bottomColor The bottom color
    -- @tparam[opt=TEXT_ALIGN_LEFT] number alignment The text alignment
    -- @tparam[opt=0] number centerSpacing The center spacing
    function mvp.ui.DrawDualText(x, y, topText, topFont, topColor, bottomText, bottomFont, bottomColor, alignment, centerSpacing)
        topFont = topFont or mvp.Font(24)
        topColor = topColor or Color(0, 127, 255, 255)
        bottomFont = bottomFont or mvp.Font(18)
        bottomColor = bottomColor or Color(255, 255, 255, 255)
        alignment = alignment or TEXT_ALIGN_LEFT
        centerSpacing = centerSpacing or 0

        surface.SetFont(topFont)
        local tw, th = surface.GetTextSize(topText)
        
        surface.SetFont(bottomFont)
        local bw, bh = surface.GetTextSize(bottomText)

        local topY = y - bh * .5
        local bottomY = y + th * .5

        draw.SimpleText(topText, topFont, x, topY + centerSpacing, topColor, alignment, TEXT_ALIGN_CENTER)
        draw.SimpleText(bottomText, bottomFont, x, bottomY - centerSpacing, bottomColor, alignment, TEXT_ALIGN_CENTER)
    end
end