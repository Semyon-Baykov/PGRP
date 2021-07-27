
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Name"
ENT.Author			= "Neotanks/V92"
ENT.Information		= ""
ENT.Category		= "Test"

ENT.Spawnable		= false
ENT.AdminOnly		= false

local	_WEP	=	{	"ins_aks74u_npc"	}

function ENT:Initialize()

	local medicDiceRoll = math.random( 1, GetConVarNumber("npcg_medicchance") )
	if medicDiceRoll == 1 then self.medicChance = 131072 else self.medicChance = 0 end
	--print("Rebel Medic Dice Roll is " .. medicDiceRoll )
	
	local rebSupplyDiceRoll = math.random( 1, GetConVarNumber("npcg_rebelresupplychance") )
	if rebSupplyDiceRoll == 1 then self.resupplyChance = 524288 else self.resupplyChance = 0 end
	--print("Rebel Supply Dice Roll is " .. rebSupplyDiceRoll )
	
	if GetConVarNumber("npcg_ignorepushing") != 0 then	self.pushNum = 16384	else	self.pushNum = 0	end
	if GetConVarNumber("npcg_weapondrop") != 0 then	self.weaponNum = 8192	else	self.weaponNum = 0	end
	if GetConVarNumber("npcg_fade_corpse") != 0 then	self.fadeNum = 512	else	self.fadeNum = 0	end
	if GetConVarNumber("npcg_longvision") != 0 then	self.longNum = 256	else	self.longNum = 0	end
	if GetConVarNumber("npcg_random_rebels") != 0 then	self.randomModel = 1	else	self.randomModel = 0	end
	
	self.kvNum = 0
	
	self.ent1 = ents.Create("npc_citizen")
	self.ent1:SetPos(self:GetPos())
	self.ent1:SetAngles( Angle( 0, math.random( 0, 360 ), 0 ) )
	self.ent1:SetKeyValue( "citizentype", 4 )
	self.ent1:SetModel("models/jessev92/kuma/characters/osama_npccit.mdl" )
	self.ent1:SetKeyValue( "DontPickupWeapons", GetConVarNumber("npcg_pickupguns") )
	self.ent1:SetKeyValue( "additionalequipment", table.Random( _WEP ) )
	self.ent1:SetKeyValue( "Expression Type", "Random" )
	self.ent1:SetKeyValue( "spawnflags", tostring( self.kvNum + self.longNum + self.weaponNum + self.pushNum + self.fadeNum + self.resupplyChance + self.medicChance ) )
	self.ent1:SetKeyValue( "wakeradius", GetConVarNumber( "npcg_wakeradius_human" ) )
	self.ent1:Spawn()
	self.ent1:Activate()
	self.ent1:SetSchedule( SCHED_IDLE_WANDER )
	
	if GetConVarNumber( "npcg_squad_human" ) != 0	then
		self.ent1:SetKeyValue( "SquadName", "HumanSquad" )
	end

	if GetConVarNumber( "npcg_squad_wakeupall" ) != 0	then	
		self.ent1:SetKeyValue( "wakesquad", 1 )	
	end

	if	GetConVarNumber("npcg_accuracy_rebel") >= 4	then
		self.ent1:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_PERFECT)
	elseif	GetConVarNumber("npcg_accuracy_rebel") == 3	then
		self.ent1:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_VERY_GOOD)
	elseif	GetConVarNumber("npcg_accuracy_rebel") == 2	then
		self.ent1:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_GOOD)
	elseif	GetConVarNumber("npcg_accuracy_rebel") == 1	then
		self.ent1:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_AVERAGE)
	else
		self.ent1:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_POOR)
	end


	timer.Simple(0, function()
	undo.Create("Osama (Friendly)")
		undo.AddEntity(self.ent1)
		undo.SetCustomUndoText("Undone Osama (Friendly)")
		undo.SetPlayer(self.Owner)
	undo.Finish()
	self:Remove()
	end)

end
