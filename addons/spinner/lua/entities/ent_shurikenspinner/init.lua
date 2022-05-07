AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")


function ENT:PhysicsCollide(data,phys)
	if data.HitEntity:GetClass() == "worldspawn" then
		self:SetPos(data.HitPos)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableCollisions(false)
			phys:Sleep()
		end
	end
end