--- @module mvp.ui
mvp.ui = mvp.ui or {}

local cosCache = {}
local sinCache = {}

local math_cos = function(value)
	if (cosCache[value]) then
		return cosCache[value]
	end

	cosCache[value] = math.cos(math.rad(value))
	return cosCache[value]
end
local math_sin = function(value)
	if (sinCache[value]) then
		return sinCache[value]
	end

	sinCache[value] = math.sin(math.rad(value))
	return sinCache[value]
end

function mvp.ui.RoundedBox(cornerRadius, x, y, w, h, noDraw)
	local poly = {}
	poly[1] = { x = x + w/2, y = y + h/2, u = 0.5, v = 0.5}

	poly[2] = {x = x + w/2, y = y, u = 0.5, v = 0}
	poly[3] = {x = x + w - cornerRadius, y = y, u = (w-cornerRadius) / w, v = 0}

	local topX = x + w-cornerRadius
	local topY = y + cornerRadius
	for i = -89, 0 do
		local X = topX + math_cos(i) * cornerRadius
		local Y = topY + math_sin(i) * cornerRadius
		poly[#poly + 1] = {
			x = X,
			y = Y,
			u = (X - x )/w,
			v = (Y - y) /h,
		}
	end

	poly[#poly + 1] = {
		x = x + w,
		y = y + h - cornerRadius,
		u =  1,
		v = (h-cornerRadius) / h,
	}

	topX = x + w-cornerRadius
	topY = y +h - cornerRadius

	for i = 1, 90 do
		local X = topX + math_cos(i) * cornerRadius
		local Y = topY + math_sin(i) * cornerRadius
		poly[#poly + 1] = {
			x = X,
			y = Y,
			u = (X - x )/w,
			v = (Y - y) /h,
		}
	end

	poly[#poly + 1] = {
		x = x +cornerRadius,
		y = y + h,
		u =  cornerRadius/w,
		v = 1,
	}

	topX = x +cornerRadius
	topY = y +h - cornerRadius

	for _i = 180, 270 do
		i = _i - 90
		local X = topX + math_cos(i) * cornerRadius
		local Y = topY + math_sin(i) * cornerRadius
		poly[#poly + 1] = {
			x = X,
			y = Y,
			u = (X - x )/w,
			v = (Y - y) /h,
		}
	end

	poly[#poly + 1] = {
		x = x,
		y = y + cornerRadius,
		u = 0,
		v = cornerRadius/h,
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
			u = (X - x )/w,
			v = (Y - y) /h,
		}
	end

	poly[#poly + 1] = {x = x + w/2, y = y, u = 0.5, v = 0}

	if not noDraw then
		surface.DrawPoly(poly)
	end
	
	return poly
end