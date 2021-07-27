
AddCSLuaFile()

if !ConVarExists( "npcg_cmbelite_ar2altdrop" ) then CreateConVar(	"npcg_cmbelite_ar2altdrop",			"0",		{	FCVAR_REPLICATED, FCVAR_ARCHIVE }	) end
if !ConVarExists( "npcg_randomizer_cmb" ) then CreateConVar(	"npcg_randomizer_cmb",				"1",		{	FCVAR_REPLICATED, FCVAR_ARCHIVE }	) end
if !ConVarExists( "npcg_wakeradius_cmb" ) then CreateConVar(	"npcg_wakeradius_cmb",				"200",		{	FCVAR_REPLICATED, FCVAR_ARCHIVE }	) end
if !ConVarExists( "npcg_healthoverride_cmb" ) then CreateConVar(	"npcg_healthoverride_cmb",	 		"150",		{	FCVAR_REPLICATED, FCVAR_ARCHIVE }	) end
if !ConVarExists( "npcg_healthoverride_cmbnp" ) then CreateConVar(	"npcg_healthoverride_cmbnp", 		"150",		{	FCVAR_REPLICATED, FCVAR_ARCHIVE }	) end
if !ConVarExists( "npcg_healthvariant_cmb" ) then CreateConVar(	"npcg_healthvariant_cmb",	 		"0",		{	FCVAR_REPLICATED, FCVAR_ARCHIVE }	) end
if !ConVarExists( "npcg_healthvariant_cmbnp" ) then CreateConVar(	"npcg_healthvariant_cmbnp",	 		"0",		{	FCVAR_REPLICATED, FCVAR_ARCHIVE }	) end

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

	if GetConVarNumber("npcg_cmbelite_ar2altdrop") != 0 then	self.ar2AltDrop = 393732	else	self.ar2AltDrop = 0	end
	if GetConVarNumber("npcg_ignorepushing") != 0 then	self.pushNum = 16384	else	self.pushNum = 0	end
	if ConVarExists("npcg_weapondrop") and GetConVarNumber("npcg_weapondrop") != 0 then	self.weaponNum = 8192	else	self.weaponNum = 0	end
	if GetConVarNumber("npcg_fade_corpse") != 0 then	self.fadeNum = 512	else	self.fadeNum = 0	end
	if GetConVarNumber("npcg_longvision") != 0 then	self.longNum = 256	else	self.longNum = 0	end
	
	self.kvNum = 0
	
	self.ent1 = ents.Create("npc_combine_s")
	self.ent1:SetPos(self:GetPos())
	self.ent1:SetAngles( Angle( 0, math.random( 0, 360 ), 0 ) )
	self.ent1:SetModel("models/jessev92/kuma/characters/osama_npccmb.mdl" )
	self.ent1:SetKeyValue( "additionalequipment", table.Random( _WEP ) )
	self.ent1:SetKeyValue( "NumGrenades", GetConVarNumber("npcg_energyballcount") )
	self.ent1:SetKeyValue( "spawnflags", tostring( self.kvNum + self.longNum + self.weaponNum + self.pushNum + self.fadeNum + self.ar2AltDrop ) )
	self.ent1:SetKeyValue( "wakeradius", GetConVarNumber( "npcg_wakeradius_cmb" ) )
	self.ent1:Spawn()
	self.ent1:Activate()
	--self.ent1:SetSchedule( SCHED_INVESTIGATE_SOUND )
	self.ent1:SetSchedule( SCHED_IDLE_WANDER )

	if GetConVarNumber( "npcg_squad_combine" ) != 0	then
		self.ent1:SetKeyValue( "SquadName", "CombineSquad" )
	end
	
	if GetConVarNumber( "npcg_squad_wakeupall" ) != 0	then	
		self.ent1:SetKeyValue( "wakesquad", 1 )	
	end

	if	GetConVarNumber("npcg_combine_tacticalvar") > 1	then
		self.ent1:SetKeyValue( "tacticalvariant", 2 )
	elseif	GetConVarNumber("npcg_combine_tacticalvar") == 1	then
		self.ent1:SetKeyValue( "tacticalvariant", 1 )
	else
		self.ent1:SetKeyValue( "tacticalvariant", 0 )
	end
	
	if	GetConVarNumber("npcg_accuracy_combine") >= 4	then
		self.ent1:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_PERFECT)
	elseif	GetConVarNumber("npcg_accuracy_combine") == 3	then
		self.ent1:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_VERY_GOOD)
	elseif	GetConVarNumber("npcg_accuracy_combine") == 2	then
		self.ent1:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_GOOD)
	elseif	GetConVarNumber("npcg_accuracy_combine") == 1	then
		self.ent1:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_AVERAGE)
	else
		self.ent1:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_POOR)	
	end

	timer.Simple(0, function()
	undo.Create("Osama (Enemy)")
		undo.AddEntity(self.ent1)
		undo.SetCustomUndoText("Undone Osama (Enemy)")
		undo.SetPlayer(self.Owner)
	undo.Finish()
	self:Remove()
	end)

end
