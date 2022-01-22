AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel("models/weapons/armor/armor.mdl")
	
	self:PhysicsInit( SOLID_VPHYSICS )     
	self:SetMoveType( MOVETYPE_VPHYSICS )  
	self:SetSolid( SOLID_VPHYSICS ) 
 
    local phys = self:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
	end
end
 
function ENT:Use( player, activator, caller )
	if player:Armor() >= 100 then
		return
	elseif player:Armor() < 100 then
		player:SetArmor(100)
		-- sound.Play("items/armor_pickup.wav", player:GetPos(), 75, 100, 1)
		self.Entity:Remove()
	end
end
 
function ENT:Think()

end