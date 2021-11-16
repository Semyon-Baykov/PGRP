
util.AddNetworkString("FishVarChange")
util.AddNetworkString("FishConfigVarChange")
util.AddNetworkString("FishConfigUpdate")
util.AddNetworkString("FishAskConfig")
util.AddNetworkString("FishConfigMenu")

resource.AddWorkshop("851911328")

local varsToSync = {FISH_CONTAINER_LIMIT = true, CAGE_NO_FISH_MODEL = true, LOCALISATION_LANGUAGE = true}
local varsToSyncNum = table.Count(varsToSync)

net.Receive("FishConfigVarChange", function(len, ply)
	if !ply:IsSuperAdmin() and !ply:IsUserGroup("superadmin") then return end
	
	local var, val = net.ReadString(), net.ReadType()

	TrueFish[var] = val
	if (varsToSync[var]) then
		net.Start("FishConfigUpdate")
		net.WriteUInt(1, 6)
		net.WriteString(var)
		net.WriteType(val)
		net.Broadcast()
	end
	
	TrueFishCfgSave()
end)

net.Receive("FishVarChange", function(len, ply)
	if !ply:IsSuperAdmin() and !ply:IsUserGroup("superadmin") then return end
	
	local var, val = net.ReadString(), net.ReadTable()
	TrueFish[var] = val
	
	TrueFishCfgSave()
	TrueFishRecalculate()
end)

net.Receive("FishAskConfig", function(len, ply)
	net.Start("FishConfigUpdate")
	net.WriteUInt(varsToSyncNum, 6)
	for k, v in pairs(varsToSync) do
		net.WriteString(k)
		net.WriteType(TrueFish[k])
	end
	net.Send(ply)
end)

function TrueFishRecalculate()
	local deepest = 0
	for i=1, FISH_HIGHNUMBER do
		if TrueFish.FISH_DEPTH[i] and TrueFish.FISH_DEPTH[i][2] > deepest then
			deepest = TrueFish.FISH_DEPTH[i][2]
		end
	end
	FISH_MAX_DEPTH = deepest
end

function TrueFishCfgSave()
	file.Write("truefish_cfg.txt", util.TableToJSON(TrueFish))
end

function TrueFishLoadCfg()
	local tbl = file.Read("truefish_cfg.txt", "DATA")
	if !tbl then return end
	tbl = util.JSONToTable(tbl)
	for k, v in pairs(tbl) do
		if type(v) == "table" then
			for k2, v2 in pairs(v) do
				TrueFish[k][k2] = v2
			end
		else
			TrueFish[k] = v
		end
	end	
	
	TrueFishRecalculate()
end
TrueFishLoadCfg()

local function TrueFishCfgDelete(ply)
	if !ply:IsSuperAdmin() and !ply:IsUserGroup("superadmin") and !ply:IsUserGroup("owner") then ply:ChatPrint("You can't do that!") return end
	file.Delete("truefish_cfg.txt")
	CompileFile("lua/autorun/sh_fishconfigs.lua")()
	ply:ChatPrint("Configuration was reset. If you experience problems, please restart the map.")
end
concommand.Add("truefish_delete_cfg", TrueFishCfgDelete)

// Addon core functions:

function TrueFishGiveMoney(ply, amt)
	if ply.addMoney then
		ply:addMoney(amt)
	elseif ply.AddMoney then
		ply:AddMoney(amt)
	elseif ply.PS_GivePoints then
		ply:PS_GivePoints(amt)
	elseif ply.PS2_AddStandardPoints then
		ply:PS2_AddStandardPoints(amt)
	end
end

function TrueFishCanAfford(ply, amt)
	if ply.canAfford then
		return ply:canAfford(amt)
	elseif ply.canAfford then
		return ply:canAfford(amt)
	elseif ply.PS_GetPoints then
		return ply:PS_GetPoints() >= amt
	elseif ply.PS2_Wallet and ply.PS2_Wallet.points then
		return ply.PS2_Wallet.points >= amt
	end
	return true // we let people buy stuff, so people can buy stuff in Sandbox for example.
end

function TrueFishNotify(ply, msg)
	ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-fishing] ', Color( 255, 255, 255 ), msg )
end

// MetaTables related to TrueFish:

local setPosEntity = FindMetaTable("Entity").SetPos // fix for the fishing rod teleport crash
FindMetaTable("Player").SetPos = function(self, pos)
	local wep = self:GetActiveWeapon()
	if wep:IsValid() and wep:GetClass() == "fishing_rod_physics" then
		for k, v in pairs(self:GetWeapons()) do
			if v:GetClass() != "fishing_rod_physics" then
				self:SelectWeapon(v:GetClass())
				break
			end
		end
	end
	
	return setPosEntity(self, pos)
end

// Hooks related to TrueFish entities:

local function TrueFishPlayerSay(ply, str, tchat)
	if string.StartWith(str, "!truefish") and !ply:IsSuperAdmin() and !ply:IsUserGroup("superadmin") then return end
	str = str:lower()
	if string.StartWith(str, "!truefish addnpc") then
		local exp = string.Explode(" ", str)
		if !exp[3] or !util.IsValidModel(exp[3]) then
			ply:ChatPrint("You've entered an invalid model.")
			return ""
		end
		ply:ChatPrint("MOVE OUT OF THE WAY!")
		local ang = ply:GetAngles()
		CreateFishingNPC(ply:GetPos(), ang.y, exp[3])
		return ""
	elseif str == "!truefish removenpc" then
		local tr = ply:GetEyeTrace()
		if IsValid(tr.Entity) then
			if DeleteFishingNPC(tr.Entity) then
				ply:ChatPrint("Fishing NPC deleted.")
				return ""
			end
		end
		ply:ChatPrint("You're not aiming at a Fishing NPC.")
		return ""
	elseif str == "!truefish config" or str == "!truefish cfg" then
		net.Start("FishConfigMenu")
		net.WriteTable(TrueFish)
		net.Send(ply)
		return ""
	elseif str == "!truefish" then
		ply:ChatPrint("Available commands: config, addnpc, removenpc.")
		return
	end
end
hook.Add("PlayerSay", "TrueFishPlayerSay", TrueFishPlayerSay)

local nextTick = 0
local curTime = CurTime
local function TrueFishTick()
	local ctime = curTime()
	if ctime > nextTick then
		nextTick = ctime + 3.3
		
		local configTTL = TrueFish.FISH_BAIT_AUTOREMOVE
		if configTTL == 0 then return end
		
		local tbl = ents.FindByClass("fish_bait")// deletes fish baits
		
		for k,v in pairs(tbl) do
			if v.SpawnTime + configTTL < ctime then
				v:Remove()
			end			
		end
	end
end
hook.Add("Tick", "TrueFishTick", TrueFishTick)

local truefishEntityNames = {fishing_pot_medium = true, fishing_pot_large = true, fish_container = true, ent_buoy = true, fishing_rod_hook = true, fish_bait = true, npc_fishshop = true}
local function TrueFishPickup(ply, ent)
	if ent:IsValid() and (ent.FishID or truefishEntityNames[ent:GetClass()]) then
		return false
	end
end
hook.Add("AllowPlayerPickup", "TrueFishPickup", TrueFishPickup)

local function TrueFishPhysPickup(ply, ent)
	local class = ent:IsValid() and ent:GetClass()
	if TrueFish.CAN_PHYSGUN_GEAR and truefishEntityNames[class] or class and class == "npc_fishshop" then
		return false
	end
end
hook.Add("PhysgunPickup", "TrueFishPhysPickup", TrueFishPhysPickup)

local function TrueFishBuoyancy(ply, ent)
	if (ent.BuoyancyRatio) then
		local phys = ent:GetPhysicsObject()
		if (phys:IsValid()) then
			timer.Simple(0, function()
				if (!phys:IsValid()) then return end
				phys:SetBuoyancyRatio(ent.BuoyancyRatio)
			end)
		end
	end
end
hook.Add("PhysgunDrop", "TrueFishBuoyancy", TrueFishBuoyancy)
hook.Add("GravGunOnDropped", "TrueFishBuoyancy", TrueFishBuoyancy)


local function TrueFishDCClean(ply)
	local tbl, SID = ents.GetAll(), ply:UserID()
	for i=1, #tbl do
		if truefishEntityNames[tbl[i]:GetClass()] and tbl[i].SID == SID then
			tbl[i]:Remove()
		end
	end
end
hook.Add("PlayerDisconnected", "TrueFishDCClean", TrueFishDCClean)

local function TrueFishToolItems(ply, tr, tool)
	if tool == "remover" and IsValid(tr.Entity) and (tr.Entity:GetClass() == "npc_fishshop" or tr.Entity.MediumBuoy)then
		return false
	end
end
hook.Add("CanTool", "TrueFishToolItems", TrueFishToolItems)

local function TrueFishPocketItems(ply, ent)
	if ent:GetClass() == "npc_fishshop" or ent.Deployed or ent.MediumBuoy then
		return false
	end
end
hook.Add("canPocket", "TrueFishPocketItems", TrueFishPocketItems)
