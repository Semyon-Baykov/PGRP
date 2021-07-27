AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

local Robber = nil


function ENT:Initialize()
	self.Entity:SetModel("models/props/cs_assault/moneypallet.mdl")
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetMoveType(SOLID_VPHYSICS)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetUseType(SIMPLE_USE)
	
	self.Entity:SetNWInt("CurrentReward", BankRS_Config["Interest"]["Base_Reward"]) --set base reward
	
	local Physics = self.Entity:GetPhysicsObject()
	
	if (Physics:IsValid()) then
	    Physics:EnableMotion(false)
	end
end

function ENT:SpawnFunction(v, tr)
    if (not tr.Hit) then return end

	local BankPos = tr.HitPos
	local Bank = ents.Create("bank_vault") 
	
	Bank:SetPos(BankPos)
	Bank:Spawn()
	Bank.Owner = v
	
	return Bank
end

function ENT:Use(ply)
	local gang = gp_gangsys_new.gang_table and gp_gangsys_new.gang_table[ply:getPlayerGangID()]
	if ply:Team() != TEAM_MOB then
		 DarkRP.notify(ply, 1, 3, "Только Глава ОПГ может запустить ограбление.")
		 return
	elseif #gang.members < 3 then
		DarkRP.notify(ply, 1, 3, "Для запуска ограбления в ОПГ должно быть минимум 3 участника!")
		return
	elseif (ply:isArrested()) then
        DarkRP.notify(ply, 1, 3, "Арестованный не может ограбить банк!")
		return 
	elseif (#player.GetAll() < BankRS_Config["Robbery"]["Min_Players"]) then
		DarkRP.notify(ply, 1, 3, "На сервере слишком мало игроков для запуска ограбления!")
	    return
	elseif (not BankRS_CountTeamNumber()) then
		DarkRP.notify(ply, 1, 3, "На сервере слишком мало полицейских для запуска ограбления!")
	    return
	elseif (timer.Exists("BankRS_RobberyTimer")) then
		DarkRP.notify(ply, 1, 3, "Кто-то уже грабит банк!")
	    return
	elseif (timer.Exists(self:EntIndex().."_CooldownTimer")) then
        DarkRP.notify(ply, 1, 3, "Банк уже ограбили.")
	    return
    end	
    
    DarkRP.notify(ply, 0, 3, "Вы запустили ограбление банка!")
    DarkRP.notify(ply, 0, 5, "Не отходите далеко от хранилища!!")
	

	
	self:DuringRobbery()
	ply:wanted(nil, "Ограбление банка")
	
	Robber = ply
	

	
	DarkRP.notifyAll(0, 10, ply:Nick().." приступил к ограблению банка!")
	umsg.Start("AdminTell")
        		umsg.String(ply:Nick().." приступил к ограблению банка!")
    	umsg.End()


    	 for k,v in pairs(player.GetAll()) do
            if v:Team() == TEAM_CHIEF or v:Team() == TEAM_POLICE or v:Team() == TEAM_MAYOR then
                umsg.Start('markmsg', v)
                    umsg.Vector( self:GetPos() )
                    umsg.String( 'Ограбление банка!' )
                    umsg.String( 'police' )
                umsg.End()
            end
        end
       
	for k,v in pairs(player.GetAll()) do

		v:ConCommand('play bankhiest/bankhiest.mp3')

	end

end

function BankRS_CountTeamNumber()
    local Team = 0
	local Banker = 0
	
	for k, v in pairs(player.GetAll()) do
	    if (table.HasValue(BankRS_Config["Robbery"]["Team_Required"]["Cops"], team.GetName(v:Team()))) then
		    Team = Team +1
		end
		
		if (table.HasValue(BankRS_Config["Robbery"]["Team_Required"]["Bankers"], team.GetName(v:Team()))) then
		    Banker = Banker +1
		end
	end
	
    if (Team >= BankRS_Config["Robbery"]["Min_Cops"] and Banker >= BankRS_Config["Robbery"]["Min_Bankers"]) then
		return true
    else
		return false
    end
end

function ENT:DuringRobbery()
	local Robbery = BankRS_Config["Robbery"]["Timer"]

    timer.Create("BankRS_RobberyTimer", 1, 0, function()
		Robbery = Robbery -1
		self:SetNWString("Status", "Ограбление: "..string.ToMinutesSeconds(Robbery))
		
		if (Robber:isArrested()) then
			DarkRP.notifyAll(1, 5, Robber:Nick().." был арестован во время ограбления!")
			self:DuringCooldown()
		elseif (not Robber:Alive()) then
			DarkRP.notifyAll(1, 5, Robber:Nick().." был убит во время ограбления!")
			self:DuringCooldown()
		elseif Robber:Team() != TEAM_MOB then
		    DarkRP.notifyAll(1, 5, Robber:Nick().." сменил работу во время ограбления!")
			self:DuringCooldown()	
		elseif (Robber:GetPos():Distance(self:GetPos()) > BankRS_Config["Robbery"]["Max_Distance"]) then
		    DarkRP.notifyAll(1, 5, Robber:Nick().." ушел слишком далеко от хранилища во время ограбления!")
			self:DuringCooldown()
		elseif (Robbery <= 0) then
		    DarkRP.notifyAll(0, 5, Robber:Nick().." успешно ограбил банк!")
			
			Robber:addMoney(self:GetNWInt("CurrentReward"))
			
			self:SetNWInt("CurrentReward", BankRS_Config["Interest"]["Base_Reward"])
			self:DuringCooldown()
        end			
	end)
end

function ENT:DuringCooldown()
    local Cooldown = BankRS_Config["Cooldown"]["Timer"]
	
	Robber:unWanted()
	Robber = nil
	

	
    timer.Remove("BankRS_RobberyTimer")	
	timer.Create(self:EntIndex().."_CooldownTimer", 1, 0, function()
		Cooldown = Cooldown -1
		self:SetNWString("Status", "До следующего ограбления: "..string.ToMinutesSeconds(Cooldown))
		
		if (Cooldown <= 0) then
			self:SetNWString("Status", "")
			timer.Remove(self:EntIndex().."_CooldownTimer")
		end
	end)
end

function ENT:OnRemove()


	timer.Remove(self:EntIndex().."_CooldownTimer")
	timer.Remove("BankRS_RobberyTimer")
end

function BankRS_AutoSpawn()
    if (file.Exists("bankrs/"..game.GetMap()..".txt", "DATA")) then
	    local JSON = util.JSONToTable(file.Read("bankrs/"..game.GetMap()..".txt", "DATA"))

		for k, v in pairs(JSON) do
	        local Bank = ents.Create("bank_vault")
	        
	        Bank:SetPos(v.pos)
	        Bank:SetAngles(v.ang)
	        Bank:Spawn()
		end
		
		MsgN("[BankRS]: Loaded "..#JSON.." positions for "..game.GetMap())
	else
	    MsgN("[BankRS]: Missing save files for "..game.GetMap())
	end
end

hook.Add("InitPostEntity", "BankRS_CheckUpdate", function()
	http.Fetch("https://dl.dropboxusercontent.com/s/90pfxdcg0mtbumu/bankVersion.txt", 
		function(version)   
	        if (version > "1.8.1") then 
			    MsgN("[BankRS]: Outdated Version DETECTED!")
			end
		end,
		
	    function(error)
		    MsgN("[BankRS]: Failed to check for UPDATES! ("..error..")")
	    end
	)
	
	BankRS_AutoSpawn()
end)

hook.Add("PlayerDeath", "BankRS_RewardKiller", function(victim, weapon, attacker)
    if (Robber == victim and victim != attacker) then
		DarkRP.notifyAll(0, 10, "Герой "..attacker:GetName().." получил "..DarkRP.formatMoney(BankRS_Config["Robbery"]["Killer_Reward"]).." за то что помешал "..victim:GetName().." ограбить банк!")
	    attacker:addMoney(BankRS_Config["Robbery"]["Killer_Reward"])
	end
end)

timer.Create("BankRS_Interest", BankRS_Config["Interest"]["Interest_Delay"], 0, function()
    for k, v in pairs(ents.FindByClass("bank_vault")) do
		if (v:GetNWString("Status") == "") then
		    v:SetNWInt("CurrentReward", math.Clamp(v:GetNWInt("CurrentReward") +BankRS_Config["Interest"]["Interest_Amount"], BankRS_Config["Interest"]["Base_Reward"], BankRS_Config["Interest"]["Reward_Max"]))
        end
	end
end)

concommand.Add("BankRS_Save", function(ply)
    if (ply:IsSuperAdmin()) then
	    if (table.Count(ents.FindByClass("bank_vault")) < 1) then
		    DarkRP.notify(ply, 1, 5, "There's no bank vaults spawned in this map!")
		else
		    local Data = {}
		
			for k, BankPos in pairs(ents.FindByClass("bank_vault")) do
			    table.insert(Data, {pos = BankPos:GetPos(), ang = BankPos:GetAngles()}) 
			    BankPos:Remove()
			end
			
			file.CreateDir("bankrs")
			file.Write("bankrs/"..game.GetMap()..".txt", util.TableToJSON(Data))
			
			DarkRP.notify(ply, 0, 10, "You've saved all of the current bank vaults' positions.")	
			BankRS_AutoSpawn()
			
			MsgN("[BankRS]: "..ply:GetName().." saved "..#Data.." positions in "..game.GetMap())
		end
    else
	    DarkRP.notify(ply, 1, 5, "You don't have permission to execute this command.")
	end
end)