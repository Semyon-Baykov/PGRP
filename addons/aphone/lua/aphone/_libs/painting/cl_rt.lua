// Convert everything
for k, v in pairs(aphone.Painting) do
	if isstring(v) then
		aphone.Painting[k] = Material(v, "smooth 1")
	end
end

// Put it in global, so we keep a trace of our textures
aphone.Texturelist = aphone.Texturelist or {}

function aphone:Painting_Generate(rt, skintbl)
	if !skintbl then return end

	render.PushRenderTarget(rt)
		render.Clear(255, 255, 255, 255)
		cam.Start2D()
			-- I don't use ipairs because it's not always sequencial tables ( like in panel painting where I remove index, but not fill gap )
			for k,v in pairs(skintbl) do
				local mat = aphone.Painting[v.mat_id]

				if !mat or mat:IsError() then continue end

				local dw = 256
				local dh = mat:Height() / mat:Width() * dw

				local tr = Matrix()
				tr:Translate(Vector(v.posx * 1024, v.posy * 1024))
				tr:Scale(Vector(v.sizex, v.sizey, 1))
				tr:Translate(Vector(-dw / 2, -dh / 2))

				cam.PushModelMatrix(tr)
					surface.SetMaterial(mat)
					surface.SetDrawColor(v.clr_r, v.clr_g, v.clr_b)
					surface.DrawTexturedRectRotated(dw / 2, dh / 2, dw, dh, v.angle)
				cam.PopModelMatrix()
			end
		cam.End2D()
	render.PopRenderTarget()
end

local function create_newplayerpaint(ply, table)
	local rt = aphone.Texturelist[ply].rt or GetRenderTargetEx( "aphone_RT_" ..  ply, 1024, 1024, RT_SIZE_OFFSCREEN, MATERIAL_RT_DEPTH_NONE, 0, 0, IMAGE_FORMAT_RGBA8888)
	local tex = aphone.Texturelist[ply].tex or CreateMaterial( "aphone_RT_" ..  ply, "VertexLitGeneric", {
		["$basetexture"] = rt:GetName()
	} )

	aphone:Painting_Generate(rt, table)

	local infos = {
		tex = tex,
		rt = rt,
		last_refresh = CurTime(),
	}

	if ply == LocalPlayer():UserID() then
		aphone.SelfPaint = table
	end

	aphone.Texturelist[ply] = infos
end

net.Receive("aphone_PaintLoad", function()
	local user_id = net.ReadUInt(16)
	local step = net.ReadUInt(6)

	local stickers = {}

	for i = 1, step do
		local tbl = {
			mat_id = net.ReadUInt(16) or 1,
			angle = net.ReadUInt(9) or 0,
			clr_r = net.ReadUInt(8) or 255,
			clr_g = net.ReadUInt(8) or 255,
			clr_b = net.ReadUInt(8) or 255,
			posx = (net.ReadUInt(10) or 50)/100,
			posy = (net.ReadUInt(10) or 50)/100,
			sizex = (net.ReadUInt(10) or 100)/100,
			sizey = (net.ReadUInt(10) or 100)/100,
		}

		table.insert(stickers, tbl)
	end

	aphone.Texturelist[user_id] = aphone.Texturelist[user_id] or {}

	create_newplayerpaint(user_id, stickers)
end)

function aphone.RefreshWeapon(ply, wep)
	if aphone.Texturelist[ply:UserID()] and (!wep.last_refresh or wep.last_refresh < aphone.Texturelist[ply:UserID()].last_refresh) then
		wep.last_refresh = CurTime()

		for k, v in pairs(aphone.matlist) do
			wep:SetSubMaterial(v, "!" .. aphone.Texturelist[ply:UserID()].rt:GetName())
		end
	end
end