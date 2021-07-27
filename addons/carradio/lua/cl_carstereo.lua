-- ▒█░░░ ▒█▀▀▀ ░█▀▀█ ▒█░▄▀ ▒█▀▀▀ ▒█▀▀▄ 　 　 　 ▒█▀▀█ ▒█░░▒█ 　 　 　 ▒█░░░ █▀▀ █▀▀█ █░█ █▀▀█ █░░█ 
-- ▒█░░░ ▒█▀▀▀ ▒█▄▄█ ▒█▀▄░ ▒█▀▀▀ ▒█░▒█ 　 　 　 ▒█▀▀▄ ▒█▄▄▄█ 　 　 　 ▒█░░░ █▀▀ █▄▄█ █▀▄ █░░█ █▀▀█ 
-- ▒█▄▄█ ▒█▄▄▄ ▒█░▒█ ▒█░▒█ ▒█▄▄▄ ▒█▄▄▀ 　 　 　 ▒█▄▄█ ░░▒█░░ 　 　 　 ▒█▄▄█ ▀▀▀ ▀░░▀ ▀░▀ ▀▀▀▀ ▀░░▀ 


local cvar_enable = CreateConVar("wyozicr_stereoenabled", "1", FCVAR_ARCHIVE)
local cvar_outside_enable = CreateConVar("wyozicr_outsidecar", "1", FCVAR_ARCHIVE)
local cvar_outside_dist = CreateConVar("wyozicr_outsidecar_distance", "256", FCVAR_ARCHIVE)
local cvar_volume = CreateConVar("wyozicr_stereovolume", "100", FCVAR_ARCHIVE)
local cvar_htmlvolmul = CreateConVar("wyozicr_htmlvolumemult", "0.5", FCVAR_ARCHIVE)

local function GetDriver(car)
	if not IsValid(car) then return end

	local plys = player.GetAll()
	for i=1,#plys do
		if plys[i]:GetVehicle() == car then
			return plys[i]
		end
	end
end

local function Media_Stop(media)
	if media.Stop then
		media:Stop()
	else
		media:stop()
	end
end
local function Media_SetVolume(media, vol)
	if media.SetVolume then
		media:SetVolume(vol)
	else
		media:setVolume(vol * cvar_htmlvolmul:GetFloat())
	end
end

hook.Add("Think", "WCR_RadioUpdater", function()
	local stereoenabled = cvar_enable:GetBool()

	for _,car in pairs(wyozicr.GetCarEnts()) do
		local carpos = car:GetPos()
		local cardriver = GetDriver(car)

		local localveh = wyozicr.GetCarEntity(LocalPlayer():GetVehicle())
		local in_local_car = IsValid(localveh) and localveh == car

		local shouldPlay = stereoenabled

		local station = car:GetNWInt("wcr_station", 0)
		local stat = wyozicr.AllStations and wyozicr.AllStations[station]

		local is_wdj = stat and stat.WDJ_Channel ~= nil

		-- Get the URL we should play and make sure we're not trying to play nil
		local stereourl = car:GetNWString("wcr_stationlink")
		if not (stereourl and stereourl ~= "") then
			stereourl = stat and stat.Link
			if (not stereourl or stereourl == "") and (not stat or not stat.WDJ_Channel) then
				shouldPlay = false
			end
		end

		local isPlaying = IsValid(car.WCR_Player)

		-- If we're not sitting inside the car, need to do some additional checks to
		-- check if we really should play radio
		if not in_local_car then
			local req_dist = cvar_outside_dist:GetFloat()

			-- if wasn't playing, we require player to be a bit closer to prevent spawm
			-- from going back and forth
			if not isPlaying then req_dist = req_dist - 100 end

			local play_outside = not is_wdj and cvar_outside_enable:GetBool() and carpos:Distance(LocalPlayer():EyePos()) < req_dist
			if not play_outside then
				shouldPlay = false
			end
		end

		-- Check if URL has changed. WDJ media needs some extra magic code to work
		local hasUrlChanged = car.WCR_Url ~= stereourl
		if is_wdj then
			local master = wdj.GetMaster(stat.WDJ_Channel)
			hasUrlChanged = IsValid(master) and (not IsValid(car.WCR_Player) or type(car.WCR_Player) ~= "table" or car.WCR_Player:getUrl() ~= master:GetCurMedia())
		end

		if isPlaying and not shouldPlay then
			MsgN("[WyoziCR] Stopping #" .. station .. " (car: " .. tostring(car) .. " - url: " .. tostring(stereourl) .. ")")

			Media_Stop(car.WCR_Player)
			car.WCR_Player = nil
		elseif shouldPlay and (hasUrlChanged or not isPlaying) and not car.WCR_StartingStereo then
			if IsValid(car.WCR_Player) then
				Media_Stop(car.WCR_Player)
				car.WCR_Player = nil
			end

			if is_wdj then
				local master = wdj.GetMaster(stat.WDJ_Channel)

				if IsValid(master) then
					local link = master:GetCurMedia()

					if link ~= "" and link ~= "--loading" then
						MsgN("[WyoziCR] Starting WDJ #" .. station .. " (car: " .. tostring(car) .. " - url: " .. tostring(link) .. ")")

						local elapsed = CurTime() - (master:GetCurMediaStarted() or CurTime())

						local service = medialib.load("media").guessService(link)
						local mediaclip = service:load(link)

						mediaclip:seek(elapsed)
						mediaclip:play()
						car.WCR_Player = mediaclip
						car.WCR_Url = nil
					end
				end
			else
				MsgN("[WyoziCR] Starting #" .. station .. " (car: " .. tostring(car) .. " - url: " .. tostring(stereourl) .. ")")

				car.WCR_StartingStereo = true
				car.WCR_Url = stereourl
				sound.PlayURL(stereourl, "3d", function(chan)
					car.WCR_StartingStereo = false
					car.WCR_Player = chan
				end)
			end
		end

-- ▒█░░░ ▒█▀▀▀ ░█▀▀█ ▒█░▄▀ ▒█▀▀▀ ▒█▀▀▄ 　 　 　 ▒█▀▀█ ▒█░░▒█ 　 　 　 ▒█░░░ █▀▀ █▀▀█ █░█ █▀▀█ █░░█ 
-- ▒█░░░ ▒█▀▀▀ ▒█▄▄█ ▒█▀▄░ ▒█▀▀▀ ▒█░▒█ 　 　 　 ▒█▀▀▄ ▒█▄▄▄█ 　 　 　 ▒█░░░ █▀▀ █▄▄█ █▀▄ █░░█ █▀▀█ 
-- ▒█▄▄█ ▒█▄▄▄ ▒█░▒█ ▒█░▒█ ▒█▄▄▄ ▒█▄▄▀ 　 　 　 ▒█▄▄█ ░░▒█░░ 　 　 　 ▒█▄▄█ ▀▀▀ ▀░░▀ ▀░▀ ▀▀▀▀ ▀░░▀ 
		
		if IsValid(car.WCR_Player) then
			local volumemul = 1

			-- if BASS, we need to set position
			if not is_wdj then
				volumemul = 1

				if in_local_car then
					car.WCR_Player:SetPos(LocalPlayer():EyePos())
					volumemul = 1
				else
					car.WCR_Player:SetPos(carpos)
					car.WCR_Player:Set3DFadeDistance(200, cvar_outside_dist:GetFloat())
				end
			end

			local vol = cvar_volume:GetFloat() or 50
			vol = vol / 100
			vol = vol * volumemul

			Media_SetVolume(car.WCR_Player, vol)
		end
	end
end)

hook.Add("EntityRemoved", "WCR_CleanUpRadio", function(ent)
	if IsValid(ent.WCR_Player) then
		Media_Stop(ent.WCR_Player)
	end
end)


-- ▒█░░░ ▒█▀▀▀ ░█▀▀█ ▒█░▄▀ ▒█▀▀▀ ▒█▀▀▄ 　 　 　 ▒█▀▀█ ▒█░░▒█ 　 　 　 ▒█░░░ █▀▀ █▀▀█ █░█ █▀▀█ █░░█ 
-- ▒█░░░ ▒█▀▀▀ ▒█▄▄█ ▒█▀▄░ ▒█▀▀▀ ▒█░▒█ 　 　 　 ▒█▀▀▄ ▒█▄▄▄█ 　 　 　 ▒█░░░ █▀▀ █▄▄█ █▀▄ █░░█ █▀▀█ 
-- ▒█▄▄█ ▒█▄▄▄ ▒█░▒█ ▒█░▒█ ▒█▄▄▄ ▒█▄▄▀ 　 　 　 ▒█▄▄█ ░░▒█░░ 　 　 　 ▒█▄▄█ ▀▀▀ ▀░░▀ ▀░▀ ▀▀▀▀ ▀░░▀ 