util.AddNetworkString("wyozicr_cradio")

net.Receive("wyozicr_cradio", function(le, cl)
	local veh = wyozicr.GetCarEntity(cl:GetVehicle())
	if not IsValid(veh) then return end

	if wyozicr.AllowedUsergroups then
		local allowed = false
		for _,ug in pairs(wyozicr.AllowedUsergroups) do
			if cl:IsUserGroup(ug) then allowed = true break end
		end
		if not allowed then
			cl:SendLua("GAMEMODE:AddNotify(\"You're not allowed to use car radio!\", NOTIFY_ERROR, 5)")
			return
		end
	end

	if veh.WCR_LastChange and veh.WCR_LastChange > CurTime() - 0.2 then
		return
	end
	veh.WCR_LastChange = CurTime()

	local off = net.ReadInt(8)
	local cur_station = veh:GetNWInt("wcr_station", 0) or 0
	if off == 0 or not off then
		if cur_station == 0 then
			veh:SetNWInt("wcr_station", veh.WCR_LastRadioStation or 1)
		else
			veh.WCR_LastRadioStation = cur_station
			veh:SetNWInt("wcr_station", 0)
		end
	else
		local newstation = (cur_station or 0) + off
		if newstation > #wyozicr.AllStations then newstation = 1 end
		if newstation < 1 then newstation = #wyozicr.AllStations end

		veh:SetNWInt("wcr_station", newstation)
	end
end)

-- ▒█░░░ ▒█▀▀▀ ░█▀▀█ ▒█░▄▀ ▒█▀▀▀ ▒█▀▀▄ 　 　 　 ▒█▀▀█ ▒█░░▒█ 　 　 　 ▒█░░░ █▀▀ █▀▀█ █░█ █▀▀█ █░░█ 
-- ▒█░░░ ▒█▀▀▀ ▒█▄▄█ ▒█▀▄░ ▒█▀▀▀ ▒█░▒█ 　 　 　 ▒█▀▀▄ ▒█▄▄▄█ 　 　 　 ▒█░░░ █▀▀ █▄▄█ █▀▄ █░░█ █▀▀█ 
-- ▒█▄▄█ ▒█▄▄▄ ▒█░▒█ ▒█░▒█ ▒█▄▄▄ ▒█▄▄▀ 　 　 　 ▒█▄▄█ ░░▒█░░ 　 　 　 ▒█▄▄█ ▀▀▀ ▀░░▀ ▀░▀ ▀▀▀▀ ▀░░▀ 

hook.Add("WDJ_AddReceivers", "WCR_AddCar", function(helper)
	for _,e in pairs(wyozicr.GetCarEnts()) do
		local ch = e:GetNWInt("wcr_station", 0)
		local stat = wyozicr.AllStations[ch]
		if stat and stat.WDJ_Channel then
			for _,p in pairs(player.GetAll()) do
				local pveh = wyozicr.GetCarEntity(p)
				if pveh == e then
					helper.addReceiver(p, stat.WDJ_Channel)
				end
			end
		end
	end
end)

-- ▒█░░░ ▒█▀▀▀ ░█▀▀█ ▒█░▄▀ ▒█▀▀▀ ▒█▀▀▄ 　 　 　 ▒█▀▀█ ▒█░░▒█ 　 　 　 ▒█░░░ █▀▀ █▀▀█ █░█ █▀▀█ █░░█ 
-- ▒█░░░ ▒█▀▀▀ ▒█▄▄█ ▒█▀▄░ ▒█▀▀▀ ▒█░▒█ 　 　 　 ▒█▀▀▄ ▒█▄▄▄█ 　 　 　 ▒█░░░ █▀▀ █▄▄█ █▀▄ █░░█ █▀▀█ 
-- ▒█▄▄█ ▒█▄▄▄ ▒█░▒█ ▒█░▒█ ▒█▄▄▄ ▒█▄▄▀ 　 　 　 ▒█▄▄█ ░░▒█░░ 　 　 　 ▒█▄▄█ ▀▀▀ ▀░░▀ ▀░▀ ▀▀▀▀ ▀░░▀ 