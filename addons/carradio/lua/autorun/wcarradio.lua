
local wyozicr_debug = SERVER and CreateConVar("wyozicr_debug", "0") or CreateClientConVar("wyozicr_debug", "0", FCVAR_ARCHIVE)

wyozicr = wyozicr or {}
function wyozicr.Debug(...)
	if not wyozicr_debug:GetBool() then return end
	print("[WCR-DEBUG] ", ...)
end
function wyozicr.IsDebug()
	return wyozicr_debug:GetBool()
end


local function AddClient(fil)
	if SERVER then AddCSLuaFile(fil) end
	if CLIENT then include(fil) end
end

local function AddServer(fil)
	if SERVER then include(fil) end
end

local function AddShared(fil)
	include(fil)
	AddCSLuaFile(fil)
end

-- ▒█░░░ ▒█▀▀▀ ░█▀▀█ ▒█░▄▀ ▒█▀▀▀ ▒█▀▀▄ 　 　 　 ▒█▀▀█ ▒█░░▒█ 　 　 　 ▒█░░░ █▀▀ █▀▀█ █░█ █▀▀█ █░░█ 
-- ▒█░░░ ▒█▀▀▀ ▒█▄▄█ ▒█▀▄░ ▒█▀▀▀ ▒█░▒█ 　 　 　 ▒█▀▀▄ ▒█▄▄▄█ 　 　 　 ▒█░░░ █▀▀ █▄▄█ █▀▄ █░░█ █▀▀█ 
-- ▒█▄▄█ ▒█▄▄▄ ▒█░▒█ ▒█░▒█ ▒█▄▄▄ ▒█▄▄▀ 　 　 　 ▒█▄▄█ ░░▒█░░ 　 　 　 ▒█▄▄█ ▀▀▀ ▀░░▀ ▀░▀ ▀▀▀▀ ▀░░▀ 

-- Doesn't work anywhere else? wut?
function wyozicr.GetCarEntity(seat_ent)

	if not IsValid(seat_ent) then return end

	 -- SCars
	local scarent = seat_ent:GetNWEntity("SCarEnt")
	if IsValid(scarent) then
		return scarent
	end

	-- simf 

	local car = seat_ent:GetDriver():GetSimfphys()
	if IsValid( car ) then
		return car
	end

	-- Sit anywhere
	if seat_ent:GetClass() == "prop_vehicle_prisoner_pod" and
		seat_ent:GetModel() == "models/nova/airboat_seat.mdl" and
		not seat_ent:GetParent():IsVehicle() then
		return
	end

	-- TDMCar stuff
	if seat_ent:GetClass() ~= "prop_vehicle_jeep" then
		return seat_ent:GetParent()
	end

	return seat_ent
end

AddShared("sh_wcr_config.lua")
AddShared("sh_wcr_stations.lua")
AddShared("sh_wcr_util.lua")
AddClient("cl_carstereo.lua")
AddClient("cl_floatyuilib.lua")
AddClient("cl_carfui.lua")
AddClient("cl_wcr_soundmuffler.lua")
AddServer("sv_carstereo.lua")
