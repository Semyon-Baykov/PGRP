hook.Add("APhone_SQLConnected", "Sync_Painting", function()
    aphone.SQLQuery("CREATE TABLE IF NOT EXISTS aphone_Painting(user INTEGER, mat_id INTEGER, angle INTEGER, clr_r INTEGER, clr_g INTEGER, clr_b INTEGER, posx INTEGER, posy INTEGER, sizex INTEGER, sizey INTEGER)")
end)

local function refresh_sql(uid, q)
	// steps
	net.Start("aphone_PaintLoad")
		net.WriteUInt(uid, 16)
		net.WriteUInt(#q, 6)

		for i = 1, #q do
			net.WriteUInt(q[i].mat_id, 16)
			net.WriteUInt(q[i].angle, 9)
			net.WriteUInt(q[i].clr_r, 8)
			net.WriteUInt(q[i].clr_g, 8)
			net.WriteUInt(q[i].clr_b, 8)
			net.WriteUInt(q[i].posx * 100, 10)
			net.WriteUInt(q[i].posy * 100, 10)
			net.WriteUInt(q[i].sizex * 100, 10)
			net.WriteUInt(q[i].sizey * 100, 10)
		end
	net.Broadcast()
end


util.AddNetworkString("aphone_PaintLoad")
hook.Add("aphone_PostUserSQL", "aphone_SendPainting", function(ply)
	aphone.SQLQuery("SELECT * FROM aphone_Painting WHERE user = " .. ply:SteamID64(), function(q)
		if !table.IsEmpty(q) then
			for i, j in pairs(q) do
				for k, v in pairs(j) do
					q[i][k] = tonumber(v)
				end
			end

			refresh_sql(ply:UserID(), q)
		end
	end)
end)

util.AddNetworkString("aphone_ChangeSticker")

local header = "INSERT INTO aphone_Painting(user, mat_id, angle, clr_r, clr_g, clr_b, posx, posy, sizex, sizey) VALUES("
net.Receive("aphone_ChangeSticker", function(_, ply)
	if !aphone.NetCD(ply, "ChangeSticker", 5) or !aphone.posinfos then return end

	local step = net.ReadUInt(6)
	if step > aphone.MaxPainting then return end

	local found_ent = false
	local pos = ply:GetPos()
	for k, v in pairs(aphone.posinfos) do
		// 300*300
		if v.pos:DistToSqr(pos) < 90000 then
			found_ent = true
			break
		end
	end

	if !found_ent then 
		print("[APhone] " .. ply:Nick() .. " tried to put stickers without NPCs around ( Did you forget to save the NPCs ? )")
		return 
	end

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

		if tbl.mat_id > aphone.MaxPainting then return end

		table.insert(stickers, tbl)
	end

	// Remove old entries
	aphone.SQLQuery("DELETE FROM aphone_Painting WHERE user = " .. ply:SteamID64())

	// Can be a big table, if servers up the aphone.MaxPainting parameter, so let's not kill perfs and use begin/commit if sqlite
	aphone.SQLBegin()
		for k, v in ipairs(stickers) do
			aphone.SQLQuery(header .. ply:SteamID64() .. ", " .. v.mat_id .. ", " .. v.angle .. ", " .. v.clr_r  .. ", " .. v.clr_g  .. ", " .. v.clr_b  .. ", " .. v.posx  .. ", " .. v.posy  .. ", " .. v.sizex  .. ", " .. v.sizey .. ")")
		end
	aphone.SQLCommit()

	refresh_sql(ply:UserID(), stickers)
end)