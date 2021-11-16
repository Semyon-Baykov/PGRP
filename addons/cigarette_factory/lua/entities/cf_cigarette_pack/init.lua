AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
include('cf_config.lua')

function ENT:Initialize()
	self.Entity:SetModel("models/cigarette_factory/cf_cigarette_pack.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON ) 
	
	local phys = self:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
	end
	
	timer.Simple( cf.cigAutoDespawnTime, function() 
		if(IsValid(self)) then
			self:Remove()
		end
	end )
end

function ENT:Use( activator, caller )
	if(!cf.allowSwep) then return end
	if !IsValid( caller ) or !caller:IsPlayer() then return end
	if(!caller.cfCanPickUp or caller:HasWeapon( "weapon_ciga_pachka_blat" )) then return end
	caller.cfCanPickUp = false
	
	caller:Give( "weapon_ciga_pachka_blat" ) 
	self:Remove()
	
	timer.Simple( 0.4, function() 
	if(IsValid(caller)) then
		caller.cfCanPickUp = true 
		end
	end )	
end
