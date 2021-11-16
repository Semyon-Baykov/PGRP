AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function MEDIC_HealthNPC_Spawn()	
	local PositionFile = file.Read("craphead_scripts/medic_system/".. string.lower( game.GetMap() ) .."/healthnpc_location.txt", "DATA")

	local ThePosition = string.Explode( ";", PositionFile )

	local TheVector = Vector( ThePosition[1], ThePosition[2], ThePosition[3] )
	local TheAngle = Angle( tonumber(ThePosition[4]), ThePosition[5], ThePosition[6] )
	
	local HealthNPC = ents.Create( "ch_npc_health" )
	HealthNPC:SetModel( CH_AdvMedic.Config.HealthNPCModel )
	HealthNPC:SetPos( TheVector )
	HealthNPC:SetAngles( TheAngle )
	HealthNPC:Spawn()
	HealthNPC:SetMoveType( MOVETYPE_NONE )
	HealthNPC:SetSolid( SOLID_BBOX )
	HealthNPC:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	
	local Indicator = ents.Create( "npc_indicator" )
	Indicator:SetPos( HealthNPC:GetPos() + ( HealthNPC:GetUp() * 90 ) )
	Indicator:SetParent( HealthNPC )
	Indicator:SetAngles( HealthNPC:GetAngles() )
	Indicator:Spawn()
	Indicator:SetCollisionGroup( COLLISION_GROUP_WORLD )
end

function ENT:Initialize()
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal()
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid( SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE )
	self:CapabilitiesAdd( CAP_TURN_HEAD )
	self:DropToFloor()
	self:SetMaxYawSpeed( 90 )
	self:SetCollisionGroup( 1 )
end

function ENT:OnTakeDamage( dmg )
	return 0
end

local function MEDIC_HealthNPC_Position( ply )
	if ply:IsAdmin() then
		local HisVector = string.Explode(" ", tostring(ply:GetPos()))
		local HisAngles = string.Explode(" ", tostring(ply:GetAngles()))
		
		file.Write("craphead_scripts/medic_system/".. string.lower(game.GetMap()) .."/healthnpc_location.txt", ""..(HisVector[1])..";"..(HisVector[2])..";"..(HisVector[3])..";"..(HisAngles[1])..";"..(HisAngles[2])..";"..(HisAngles[3]).."", "DATA")
		ply:ChatPrint( "New position for the health/armor NPC has been succesfully set." )
		ply:ChatPrint( "The NPC will respawn in 5 seconds. Move out the way." )
		
		-- Respawn the ambulance npc
		for k, ent in ipairs( ents.GetAll() ) do
			if ent:GetClass() == "ch_npc_health" and IsValid( ent ) then
				ent:Remove()
			end
		end
		
		timer.Simple( 5, function()
			if IsValid( ply ) then
				MEDIC_HealthNPC_Spawn()
				ply:ChatPrint( "The health/armor NPC has been respawned." )
			end
		end )
	else
		ply:ChatPrint( "Only administrators can perform this action" )
	end
end
concommand.Add( "paramedic_healthnpc_setpos", MEDIC_HealthNPC_Position )

function ENT:AcceptInput( ply, caller )
	if caller:IsPlayer() and ( self.lastUsed or CurTime() ) <= CurTime() then

		self.lastUsed = CurTime() + 1
		
		local RequiredTeamsCount = 0
		local RequiredPlayersCounted = 0
	
		for k, v in ipairs( player.GetAll() ) do
			RequiredPlayersCounted = RequiredPlayersCounted + 1
			
			if table.HasValue( CH_AdvMedic.Config.AllowedTeams, team.GetName( v:Team() ) ) then
				RequiredTeamsCount = RequiredTeamsCount + 1
			end
			
			if RequiredPlayersCounted == #player.GetAll() then
				if not CH_AdvMedic.Config.OnlyWorkIfNoMedics then
					if RequiredTeamsCount < CH_AdvMedic.Config.RequiredMedics then
						DarkRP.notify( caller, 1, 5, CH_AdvMedic.Config.Lang["The minimum required paramedics for this service to be available is"][CH_AdvMedic.Config.Language].. " ".. CH_AdvMedic.Config.RequiredMedics )
						return
					end
				else
					if RequiredTeamsCount > 0 then
						--DarkRP.notify( caller, 1, 5, CH_AdvMedic.Config.Lang["The minimum required paramedics for this service to be available is"][CH_AdvMedic.Config.Language].. " ".. CH_AdvMedic.Config.RequiredMedics )
						DarkRP.notify( caller, 1, 5, "You can only use this service if there are no paramedics on duty!" )
						return
					end
				end
			end
		end
		
		net.Start( "ADV_MEDIC_HealthMenu", caller )
		net.Send( caller )
	end
end

net.Receive( "ADV_MEDIC_PurchaseHealth", function( length, ply )
	if ( ply.CH_ADV_MEDIC_NetRateLimit or CurTime() ) > CurTime() then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_ADV_MEDIC_NetRateLimit = CurTime() + 1.5
	
	if not CH_AdvMedic.Config.NPCSellHealth then
		DarkRP.notify( ply, 1, 5, CH_AdvMedic.Config.Lang["The server has disabled this feature!"][CH_AdvMedic.Config.Language] )
		return
	end
	
	-- Distance check
	for k, npc in ipairs( ents.FindByClass( "ch_npc_health" ) ) do
		if ply:GetPos():DistToSqr( npc:GetPos() ) > 10000 then
			DarkRP.notify( ply, 1, 5, CH_AdvMedic.Config.Lang["You are too far away from the NPC!"][CH_AdvMedic.Config.Language] )
			return
		end
	end
	
	-- Check if health is full
	if ply:Health() >= ply:GetMaxHealth() then
		DarkRP.notify( ply, 1, 5, CH_AdvMedic.Config.Lang["Your health is already at maximum."][CH_AdvMedic.Config.Language] )
		return
	end
	
	-- All good heal player!
	if ply:getDarkRPVar("money") >= CH_AdvMedic.Config.HealthPrice then
		ply:SetHealth( ply:GetMaxHealth() )
		DarkRP.notify( ply, 1, 5, CH_AdvMedic.Config.Lang["Your health has been refilled. You have been charged"][CH_AdvMedic.Config.Language].. " ".. DarkRP.formatMoney( CH_AdvMedic.Config.HealthPrice ) )
		ply:addMoney( CH_AdvMedic.Config.HealthPrice * - 1 )
	else
		DarkRP.notify( ply, 1, 5, CH_AdvMedic.Config.Lang["You cannot afford this"][CH_AdvMedic.Config.Language] )
	end
end )

net.Receive( "ADV_MEDIC_PurchaseArmor", function( length, ply )
	if ( ply.CH_ADV_MEDIC_NetRateLimit or CurTime() ) > CurTime() then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_ADV_MEDIC_NetRateLimit = CurTime() + 1.5
	
	if not CH_AdvMedic.Config.NPCSellArmor then
		DarkRP.notify( ply, 1, 5, CH_AdvMedic.Config.Lang["The server has disabled this feature!"][CH_AdvMedic.Config.Language] )
		return
	end
	
	-- Distance check
	for k, npc in ipairs( ents.FindByClass( "ch_npc_health" ) ) do
		if ply:GetPos():DistToSqr( npc:GetPos() ) > 10000 then
			DarkRP.notify( ply, 1, 5, CH_AdvMedic.Config.Lang["You are too far away from the NPC!"][CH_AdvMedic.Config.Language] )
			return
		end
	end
	
	-- Check if armor is full
	if ply:Armor() >= 100 then
		DarkRP.notify( ply, 1, 5, CH_AdvMedic.Config.Lang["Your armor is already at maximum."][CH_AdvMedic.Config.Language] )
		return
	end
	
	-- All good heal player!
	if ply:getDarkRPVar( "money" ) >= CH_AdvMedic.Config.ArmorPrice then
		ply:SetArmor( 100 )
		DarkRP.notify( ply, 1, 5, CH_AdvMedic.Config.Lang["Your armor has been refilled. You have been charged"][CH_AdvMedic.Config.Language].. " ".. DarkRP.formatMoney( CH_AdvMedic.Config.ArmorPrice ) )
		ply:addMoney( CH_AdvMedic.Config.ArmorPrice * - 1 )
	else
		DarkRP.notify( ply, 1, 5, CH_AdvMedic.Config.Lang["You cannot afford this!"][CH_AdvMedic.Config.Language] )
	end
end )