
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()	
	self:SetModel("models/props_junk/garbage_bag001a.mdl")
	self:SetMaterial("models/flesh")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetPos(self:GetPos()+Vector(0, 0, 13))
	local phys = self:GetPhysicsObject()    
	if phys:IsValid() then
		phys:Wake()
	end

end

function ENT:Use(activator, caller)
	if !caller.FishBait or caller.FishBait < TrueFish.ROD_FISH_BAIT_AMOUNT then
		caller.FishBait = TrueFish.ROD_FISH_BAIT_AMOUNT
		TrueFishNotify(caller, TrueFishLocal("picked_up_fish_bait", TrueFish.ROD_FISH_BAIT_AMOUNT))
		self:Remove()
	end
end

function ENT:Touch(Ent)
	if Ent.NeedsBait then
		net.Start("FishPotUpdate")
		net.WriteEntity(Ent)
		net.WriteUInt(2, 2)
		net.Broadcast()
		Ent.NeedsBait = false
		self:Remove()
	end
end