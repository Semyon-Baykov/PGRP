--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[
--[[--[[--[[	Hey! Thanks for extracting this addon!					--[[--[[--[[
--]]--]]--]]	There isn't much here, but feel free to look around!	--]]--]]--]]
--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]


AddCSLuaFile()
if SERVER then
	if not ConVarExists("spp_ignore_vehicles") then CreateConVar( "spp_ignore_vehicles", "1", {FCVAR_NOTIFY,FCVAR_REPLICATED, FCVAR_ARCHIVE} ) end
	
	if not ConVarExists("physgun_freeze") then CreateConVar( "physgun_freeze", "1", {FCVAR_NOTIFY,FCVAR_REPLICATED, FCVAR_ARCHIVE} ) end
	if not ConVarExists("physgun_reload") then CreateConVar( "physgun_reload", "1", {FCVAR_NOTIFY,FCVAR_REPLICATED, FCVAR_ARCHIVE} ) end
	if not ConVarExists("physspawn_stop") then CreateConVar( "physspawn_stop", "1", {FCVAR_NOTIFY,FCVAR_REPLICATED, FCVAR_ARCHIVE} ) end
end


-- Prop gets frozen when touched and let go with a physgun.
function FreezeProp(ply, ent)

	if GetConVarNumber("spp_ignore_vehicles") > 0 and ent:IsVehicle() then return end
	
	if GetConVarNumber("physgun_freeze") > 0 then
	
		local PhysObj = ent:GetPhysicsObject()
		
		if IsValid(PhysObj) then
			PhysObj:EnableMotion( false )
		end
		
	end
	
end

-- Disables unfreezing a prop with physgun reload.
function StopReload(ply, ent)
	
	if GetConVarNumber("physgun_reload") > 0 then
	
		local PhysObj = ent:GetPhysicsObject()
		if IsValid(PhysObj) then return false end
	
	end
	
end

-- Freeze props right away when a players spawns them
function FreezeSpawnedProps(ply, model, ent)
	if ent:IsValid() then
		
		if GetConVarNumber("spp_ignore_vehicles") > 0 and ent:IsVehicle() then return end
	
		if GetConVarNumber("physspawn_stop") > 0 then
	
			local PhysObj = ent:GetPhysicsObject()
			PhysObj:EnableMotion(false)
		
			--for k,v in pairs(ents.FindByClass("prop_physics")) do		<-- This freezes all props lol
			--	v:GetPhysicsObject():EnableMotion(false)
			--end
		
		end

	end
end

hook.Add("PhysgunDrop", "PhysgunFreeze", FreezeProp )
hook.Add("OnPhysgunReload", "StopUnFreezePhysProp", StopReload)
hook.Add("PlayerSpawnedProp", "FreezeSpawnedProps", FreezeSpawnedProps)