--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[--[[
--[[--[[--[[	Hey! Thanks for extracting this addon!					--[[--[[--[[
--]]--]]--]]	There isn't much here, but feel free to look around!	--]]--]]--]]
--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]--]]


AddCSLuaFile()
if SERVER then
	if not ConVarExists("pgrp_ignore_vehicles") then CreateConVar( "pgrp_ignore_vehicles", "1", {FCVAR_NOTIFY,FCVAR_REPLICATED, FCVAR_ARCHIVE} ) end
	
	if not ConVarExists("pgrp_physgun_freeze") then CreateConVar( "pgrp_physgun_freeze", "1", {FCVAR_NOTIFY,FCVAR_REPLICATED, FCVAR_ARCHIVE} ) end
	if not ConVarExists("pgrp_physgun_reload") then CreateConVar( "pgrp_physgun_reload", "1", {FCVAR_NOTIFY,FCVAR_REPLICATED, FCVAR_ARCHIVE} ) end
	if not ConVarExists("pgrp_physspawn_stop") then CreateConVar( "pgrp_physspawn_stop", "1", {FCVAR_NOTIFY,FCVAR_REPLICATED, FCVAR_ARCHIVE} ) end
end


-- Prop gets frozen when touched and let go with a physgun.
function FreezeProp(ply, ent)
	if GetConVarNumber("pgrp_ignore_vehicles") > 0 and ent:IsVehicle() then return end
	
	if GetConVarNumber("pgrp_physgun_freeze") > 0 then
	
		local PhysObj = ent:GetPhysicsObject()
		
		if IsValid(PhysObj) then
			PhysObj:EnableMotion( false )
		end
		
	end
	
end

-- Disables unfreezing a prop with physgun reload.
function StopReload(ply, ent)

	if GetConVarNumber("pgrp_ignore_vehicles") > 0 and ent:IsVehicle() then return true end
	
	if GetConVarNumber("pgrp_physgun_reload") > 0 then
	
		local PhysObj = ent:GetPhysicsObject()
		if IsValid(PhysObj) then return false end
	
	end
	
end

-- Freeze props right away when a players spawns them
function FreezeSpawnedProps(ply, model, ent)
	if ent:IsValid() then
		
		if GetConVarNumber("pgrp_ignore_vehicles") > 0 and ent:IsVehicle() then return end
	
		if GetConVarNumber("pgrp_physspawn_stop") > 0 then
	
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