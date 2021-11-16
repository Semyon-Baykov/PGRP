AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function FIRE_TruckNPC_Spawn()	
	if not file.IsDir("craphead_scripts", "DATA") then
		file.CreateDir("craphead_scripts", "DATA")
	end
	
	if not file.IsDir("craphead_scripts/fire_system/".. string.lower(game.GetMap()) .."", "DATA") then
		file.CreateDir("craphead_scripts/fire_system/".. string.lower(game.GetMap()) .."", "DATA")
	end
	
	if not file.Exists( "craphead_scripts/fire_system/".. string.lower(game.GetMap()) .."/firetrucknpc_location.txt", "DATA" ) then
		file.Write("craphead_scripts/fire_system/".. string.lower(game.GetMap()) .."/firetrucknpc_location.txt", "0;-0;-0;0;0;0", "DATA")
	end
	
	local PositionFile = file.Read("craphead_scripts/fire_system/".. string.lower(game.GetMap()) .."/firetrucknpc_location.txt", "DATA")
	 
	local ThePosition = string.Explode( ";", PositionFile )
		
	local TheVector = Vector(ThePosition[1], ThePosition[2], ThePosition[3])
	local TheAngle = Angle(tonumber(ThePosition[4]), ThePosition[5], ThePosition[6])
	
	local FiretruckNPC = ents.Create("npc_firetruck")
	FiretruckNPC:SetModel( CH_FireSystem.Config.NPCModel )
	FiretruckNPC:SetPos( TheVector )
	FiretruckNPC:SetAngles( TheAngle )
	FiretruckNPC:Spawn()
	FiretruckNPC:SetMoveType( MOVETYPE_NONE )
	FiretruckNPC:SetSolid( SOLID_BBOX )
	FiretruckNPC:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	
	if CH_FireSystem.Config.OverheadSpinningBubble then
		local Indicator = ents.Create( "npc_indicator" )
		if CH_FireSystem.Config.OverheadTextDisplay then
			Indicator:SetPos( FiretruckNPC:GetPos() + ( FiretruckNPC:GetUp() * 95 ) )
		else
			Indicator:SetPos( FiretruckNPC:GetPos() + ( FiretruckNPC:GetUp() * 90 ) )
		end
		Indicator:SetParent( FiretruckNPC )
		Indicator:SetAngles( FiretruckNPC:GetAngles() )
		Indicator:Spawn()
		Indicator:SetCollisionGroup( COLLISION_GROUP_WORLD )
	end
end
hook.Add( "InitPostEntity", "FIRE_TruckNPC_Spawn", FIRE_TruckNPC_Spawn )

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

function FIRE_TruckNPC_Position( ply )
	if ply:IsAdmin() then
		local HisVector = string.Explode(" ", tostring(ply:GetPos()))
		local HisAngles = string.Explode(" ", tostring(ply:GetAngles()))
		
		file.Write("craphead_scripts/fire_system/".. string.lower(game.GetMap()) .."/firetrucknpc_location.txt", ""..(HisVector[1])..";"..(HisVector[2])..";"..(HisVector[3])..";"..(HisAngles[1])..";"..(HisAngles[2])..";"..(HisAngles[3]).."", "DATA")
		ply:ChatPrint( CH_FireSystem.Config.Lang["New position for the firetruck NPC has been succesfully set!"][CH_FireSystem.Config.Language] )
		ply:ChatPrint( CH_FireSystem.Config.Lang["The NPC will respawn in 5 seconds. Move out the way."][CH_FireSystem.Config.Language] )
		
		-- Respawn the NPC after 5 seconds
		-- 76561198051291901
		for k, v in pairs( ents.FindByClass( "npc_firetruck" ) ) do
			if IsValid( v ) then
				v:Remove()
			end
		end
		timer.Simple( 5, function()
			FIRE_TruckNPC_Spawn()
			ply:ChatPrint( CH_FireSystem.Config.Lang["The NPC has been respawned."][CH_FireSystem.Config.Language] )
		end )
	else
		ply:ChatPrint( CH_FireSystem.Config.Lang["Only administrators can perform this action!"][CH_FireSystem.Config.Language] )
	end
end
concommand.Add( "firetrucknpc_setpos", FIRE_TruckNPC_Position )

util.AddNetworkString( "FIRE_FiretruckMenu" )
function ENT:AcceptInput( ply, caller )
	if caller:IsPlayer() and ( self.lastUsed or CurTime() ) <= CurTime() then
		self.lastUsed = CurTime() + 1.5

		if IsValid( caller ) and caller:IsFireFighter() then
			net.Start( "FIRE_FiretruckMenu" )
			net.Send( caller )
		else
			DarkRP.notify( caller, 1, 5,  CH_FireSystem.Config.Lang["Only firefighters can access this NPC!"][CH_FireSystem.Config.Language] )
		end
	end
end

function ENT:OnTakeDamage( dmg )
	return 0
end