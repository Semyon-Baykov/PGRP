local function GetAngPos_Old(ply, seat, veh)
	local posang = seat:GetAttachment(seat:LookupAttachment("vehicle_driver_eyes"))
	if not posang then return end

	local pos

	local ang = posang.Ang
	ang.p = 0

	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )

	pos = veh:LocalToWorld(veh:OBBCenter()) + ang:Up() * -28
	pos.z =  posang.Pos.z

	local diff = veh:WorldToLocal(ply:EyePos()) - veh:WorldToLocal(pos)
	local diffx = diff.x
	local sittingonleft = diffx < 0

	if sittingonleft then
		pos = pos + ang:Forward() * diffx*0.25
	end

	local ep = LocalPlayer():EyePos()
	local epdist = ep:Distance(pos)

	-- this stupid hack brings the UI closer if its in the front-seat range
	if epdist > 35 and epdist < 60 then
		pos = ep + (pos-ep):GetNormalized()*35
	end

	return pos, ang
end

local function GetAngPos_Experimental(ply, seat, veh)
	local posang = seat:GetAttachment(seat:LookupAttachment("vehicle_driver_eyes"))
	if not posang then return end

	local driver_eyes_local = veh:WorldToLocal(posang.Pos)
	local mid_local = veh:WorldToLocal(veh:WorldSpaceCenter())

	local driver_on_left = mid_local.x > driver_eyes_local.x

	local me_on_left_diff = mid_local.x - veh:WorldToLocal(LocalPlayer():EyePos()).x
	local me_on_left = me_on_left_diff > 0

	local pos = mid_local
	pos.x = pos.x - 8 -- To center the FUI we use an arbitrary number cuz yolo
	pos.y = driver_eyes_local.y + 27
	pos.z = driver_eyes_local.z + 3

	local ang = posang.Ang
	ang.p = 0

	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 90)

	--abs check fixes porsche tricycle and other dumb oneperson vehicles
	if math.abs(me_on_left_diff) > 5 then
		ang:RotateAroundAxis(ang:Right(), me_on_left and 10 or -10)
	end

	return veh:LocalToWorld(pos), ang
end

local cvar_useexp = CreateConVar("wyozicr_exp_uipos", "1", FCVAR_ARCHIVE)
local function GetAngPos(ply, seat, veh)
	if cvar_useexp:GetBool() then
		return GetAngPos_Experimental(ply, seat, veh)
	end
	return GetAngPos_Old(ply, seat, veh)
end

local SpeedVals = {}
local SpeedUpdval = 0
local NextSVUpd
CreateClientConVar("wyozicr_fancyspeed", "0")

local bg_hover_color = Color(192, 57, 43)
local bg_color = Color(44, 62, 80, 200)
local border_color = Color(44, 62, 80)

local CarPanelPainter = function(self, tbl)
	local x, y = self:GetPos()
	local w, h = self:GetSize()

	surface.SetDrawColor(bg_color)
	surface.DrawRect(x, y, w, h)

	return self.BaseUI.Paint(self, tbl)

end

-- ▒█░░░ ▒█▀▀▀ ░█▀▀█ ▒█░▄▀ ▒█▀▀▀ ▒█▀▀▄ 　 　 　 ▒█▀▀█ ▒█░░▒█ 　 　 　 ▒█░░░ █▀▀ █▀▀█ █░█ █▀▀█ █░░█ 
-- ▒█░░░ ▒█▀▀▀ ▒█▄▄█ ▒█▀▄░ ▒█▀▀▀ ▒█░▒█ 　 　 　 ▒█▀▀▄ ▒█▄▄▄█ 　 　 　 ▒█░░░ █▀▀ █▄▄█ █▀▄ █░░█ █▀▀█ 
-- ▒█▄▄█ ▒█▄▄▄ ▒█░▒█ ▒█░▒█ ▒█▄▄▄ ▒█▄▄▀ 　 　 　 ▒█▄▄█ ░░▒█░░ 　 　 　 ▒█▄▄█ ▀▀▀ ▀░░▀ ▀░▀ ▀▀▀▀ ▀░░▀ 

local function CreateBtnPainter(clr, img, text)
	return function(self, tbl)
		local x, y = self:GetPos()
		local w, h = self:GetSize()

		if tbl.mx and tbl.my and self:Contains(tbl.mx, tbl.my) then
			surface.SetDrawColor(bg_hover_color)
		else
			surface.SetDrawColor(clr)
		end
		surface.DrawRect(x, y, w, h)

		if img then
			surface.SetMaterial(img)
			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.DrawTexturedRect(x+w/2-25, y+h/2-25, 50, 50)
		end
		if text then
			draw.SimpleText(text, "FloatyMedium", x + w/2, y + h/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		return self.BaseUI.Paint(self, tbl)
	end
end

local function CreateCarFUI()
	local pane = wyozicr.floatyui.Create("Panel")
	pane.Paint = function(self, tbl)
		self.BaseUI.Paint(self, tbl) -- Draw children

		if tbl.mx and tbl.my and self:Contains(tbl.mx, tbl.my) then
			surface.SetDrawColor(Color(255, 0, 0, 255))
			surface.DrawLine(tbl.mx - 10, tbl.my, tbl.mx + 10, tbl.my)
			surface.DrawLine(tbl.mx, tbl.my - 10, tbl.mx, tbl.my + 10)
		end
	end
	pane:SetSize(500, 230)

	do
		local subpane = pane:Add("Panel")
		subpane.Paint = CarPanelPainter
		subpane:SetPos(0, 0)
		subpane:SetSize(500, 230)

		do
			local lbl = subpane:Add("Label", "Радио", "FloatySmall", nil, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			lbl:SetPos(250, 40)
		end

		do
			local lbl = subpane:Add("Label", "CurStation", "FloatySmall", nil, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			lbl:SetPos(250, 80)
			pane.StationLabel = lbl

			local prevlbl = subpane:Add("Label", "PrevStation", "FloatyVerySmall", Color(150, 150, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			prevlbl:SetPos(10, 83)
			pane.PrevStationLabel = prevlbl

			local nextlbl = subpane:Add("Label", "NextStation", "FloatyVerySmall", Color(150, 150, 150), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
			nextlbl:SetPos(490, 83)
			pane.NextStationLabel = nextlbl
		end

		do
			local btn = subpane:Add("Panel")
			btn:SetPos(20, 110)
			btn:SetSize(100, 100)
			local icon = Material("icon16/arrow_left.png")
			btn.Paint = CreateBtnPainter(Color(255, 255, 255, 20), icon)
			btn.DoClick = function()
				local veh = LocalPlayer():GetVehicle()
				if not IsValid(veh) then return end
				net.Start("wyozicr_cradio")
					net.WriteInt(-1, 8)
				net.SendToServer()
			end
		end

		do
			local btn = subpane:Add("Panel")
			btn:SetPos(380, 110)
			btn:SetSize(100, 100)
			local icon = Material("icon16/arrow_right.png")
			btn.Paint = CreateBtnPainter(Color(255, 255, 255, 20), icon)
			btn.DoClick = function()
				local veh = LocalPlayer():GetVehicle()
				if not IsValid(veh) then return end
				net.Start("wyozicr_cradio")
					net.WriteInt(1, 8)
				net.SendToServer()
			end
		end

		do
			local btn = subpane:Add("Panel")
			btn:SetPos(130, 110)
			btn:SetSize(240, 100)
			btn.Paint = CreateBtnPainter(Color(255, 255, 255, 20), nil, "Вкл/Выкл")
			btn.DoClick = function()
				net.Start("wyozicr_cradio")
					net.WriteInt(0, 8)
				net.SendToServer()
			end
		end
	end

	return pane
end

-- autorefresh should refresh the FUI as well
wyozicr.CarFUI = nil

local function PrepareSubStationName(name, spaceleft, lbl)
	spaceleft = math.max(spaceleft, 40)

	lbl.Text = name
	local spaceused = lbl:GetTextSize()
	while spaceused > spaceleft do
		lbl.Text = lbl.Text:sub(1, lbl.Text:len()-1)
		spaceused = lbl:GetTextSize()
	end
end
/*
hook.Add("PostDrawTranslucentRenderables", "WCR_FUIRenderer", function()
	local ply = LocalPlayer()

	local seat = ply:GetVehicle()
	local veh = wyozicr.GetCarEntity(seat)	-- SCar stuff

	if not IsValid(veh) then return end

	local fui = wyozicr.CarFUI
	if not fui or cvars.Bool("wyozicr_debug") then
		fui = CreateCarFUI()
		wyozicr.CarFUI = fui
	end

	local cur_station = veh::
	local cs_name, cs_url = veh:GetNWString("wcr_stationname"), veh:GetNWString("wcr_stationlink")

	local stereochan, prevschan, nextschan = "-", "", ""
	do
		stereochan = cs_name or cs_url or ""
		if stereochan == "" then
			local station = wyozicr.AllStations[cur_station]
			if station then
				stereochan = station.Name
				local prevchan, nextchan = (cur_station-1), (cur_station+1)
				if prevchan < 1 then prevchan = #wyozicr.AllStations end
				if nextchan > #wyozicr.AllStations then nextchan = 1 end

				prevschan = wyozicr.AllStations[prevchan] and wyozicr.AllStations[prevchan].Name or ""
				nextschan = wyozicr.AllStations[nextchan] and wyozicr.AllStations[nextchan].Name or ""
			else
				stereochan = "Выключено."
			end
		end
	end

	if fui.StationLabel then
		fui.StationLabel.Text = stereochan
		local tw = fui.StationLabel:GetTextSize()

		local spaceleft = 230 - (tw/2)

		local prevlbl, nextlbl = fui.PrevStationLabel, fui.NextStationLabel

		prevlbl.Text = prevschan
		nextlbl.Text = nextschan

		local plw = prevlbl:GetTextSize()
		local nlw = nextlbl:GetTextSize()

		spaceleft = math.min(spaceleft, math.min(plw, nlw))

		PrepareSubStationName(prevschan, spaceleft, fui.PrevStationLabel)
		PrepareSubStationName(nextschan, spaceleft, fui.NextStationLabel)
	end

	local pos, ang = GetAngPos(ply, seat, veh)

	if not pos or not ang then return end

	fui.PaintTbl.clicked = wyozicr.FuiClicked
	wyozicr.FuiClicked = false

	fui:SetRenderData(pos, ang, 0.02)
	fui:Render()

end)

hook.Add("GUIMousePressed", "WCR_GuiMouse", function()
	if IsValid(LocalPlayer():GetVehicle()) then
		wyozicr.FuiClicked = true
	end
end)

hook.Add("PlayerBindPress", "WCR_BindPress", function(ply, bind, press)
	if (bind == "+attack" or bind == "+use") and press and IsValid(LocalPlayer():GetVehicle()) then
		local mix, max
		if wyozicr.CarFUI then
			mix, max = wyozicr.CarFUI:TranslateToFloatyCoords()
			if mix and max and wyozicr.CarFUI:Contains(mix, max) then
				wyozicr.FuiClicked = true
				return true
			end
		end
	end
end)
*/