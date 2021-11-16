AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function MEDIC_TruckNPC_Spawn()
	local PositionFile = file.Read( "craphead_scripts/medic_system/".. string.lower( game.GetMap() ) .."/ambulancenpc_location.txt", "DATA" )
	
	local ThePosition = string.Explode( ";", PositionFile )
	
	local TheVector = Vector( ThePosition[1], ThePosition[2], ThePosition[3] )
	local TheAngle = Angle( tonumber( ThePosition[4]), ThePosition[5], ThePosition[6] )
	
	local AmbulanceNPC = ents.Create( "ch_npc_ambulance" )
	AmbulanceNPC:SetModel( CH_AdvMedic.Config.NPCModel )
	AmbulanceNPC:SetPos( TheVector )
	AmbulanceNPC:SetAngles( TheAngle )
	AmbulanceNPC:Spawn()
	AmbulanceNPC:SetMoveType( MOVETYPE_NONE )
	AmbulanceNPC:SetSolid( SOLID_BBOX )
	AmbulanceNPC:SetCollisionGroup( COLLISION_GROUP_PLAYER )

	local Indicator = ents.Create( "npc_indicator" )
	Indicator:SetPos( AmbulanceNPC:GetPos() + ( AmbulanceNPC:GetUp() * 90 ) )
	Indicator:SetParent( AmbulanceNPC )
	Indicator:SetAngles( AmbulanceNPC:GetAngles() )
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

local function MEDIC_TruckNPC_Position( ply )
	if ply:IsAdmin() then
		local HisVector = string.Explode(" ", tostring(ply:GetPos()))
		local HisAngles = string.Explode(" ", tostring(ply:GetAngles()))
		
		file.Write("craphead_scripts/medic_system/".. string.lower(game.GetMap()) .."/ambulancenpc_location.txt", ""..(HisVector[1])..";"..(HisVector[2])..";"..(HisVector[3])..";"..(HisAngles[1])..";"..(HisAngles[2])..";"..(HisAngles[3]).."", "DATA")
		ply:ChatPrint( "New position for the ambulance NPC has been succesfully set." )
		ply:ChatPrint( "The NPC will respawn in 5 seconds. Move out the way." )
		
		-- Respawn the ambulance npc
		for k, ent in ipairs( ents.GetAll() ) do
			if ent:GetClass() == "ch_npc_ambulance" and IsValid( ent ) then
				ent:Remove()
			end
		end
		
		timer.Simple( 5, function()
			if IsValid( ply ) then
				MEDIC_TruckNPC_Spawn()
				ply:ChatPrint( "The ambulance NPC has been respawned." )
			end
		end )
	else
		ply:ChatPrint( "Only administrators can perform this action" )
	end
end
concommand.Add( "paramedic_ambulancenpc_setpos", MEDIC_TruckNPC_Position )

function ENT:AcceptInput(ply, caller)
	if caller:IsPlayer() and ( self.lastUsed or CurTime() ) <= CurTime() then

		self.lastUsed = CurTime() + 1

		if IsValid( caller ) and table.HasValue( CH_AdvMedic.Config.AllowedTeams, team.GetName( caller:Team() ) ) then
			net.Start( "ADV_MEDIC_AmbulanceMenu", caller )
			net.Send( caller )
		else
			DarkRP.notify( caller, 1, 5,  CH_AdvMedic.Config.Lang["Only paramedics can access this NPC!"][CH_AdvMedic.Config.Language] )
		end
	end
end