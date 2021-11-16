
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Fishing Rod Pole"
ENT.Author			= "Tomasas"

function ENT:SetupDataTables()
	self:DTVar("Entity", 0, "Player")
	self:DTVar("Entity", 1, "Hook")
end
