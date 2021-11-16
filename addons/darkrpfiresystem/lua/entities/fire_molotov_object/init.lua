AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/ocrp2/props_meow/weapons/w_molotov.mdl" )

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	self:SetAngles( Angle( math.random(0, 360), math.random(0, 360), math.random(0, 360) ) )
	
	local phys = self:GetPhysicsObject()
	
	if not phys or not IsValid( phys ) then return end
	
	self:GetPhysicsObject():Wake()
end

function ENT:PhysicsCollide( data, obj )
 	if not data.HitEntity:IsPlayer() then
		local trace = {}
		trace.start = data.HitPos
		trace.endpos = data.HitPos - Vector( 0, 0, 2000 )
		trace.mask = MASK_OPAQUE
		
		local tr = util.TraceLine( trace )
		if tr.Hit then
			sound.Play( "physics/glass/glass_cup_break" .. math.random(1, 2) .. ".wav", tr.HitPos, 150, 150 )
			
			local Fire = ents.Create( "fire" )
			Fire:SetPos( tr.HitPos )
			Fire:Spawn()
			
			self:Remove()
		end
	else
		data.HitEntity:Ignite( 40, 10 )
	end
end