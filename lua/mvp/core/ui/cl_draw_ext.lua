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
end

do 
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