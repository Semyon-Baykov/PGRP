
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Buoy"
ENT.Purpose			= "Less buggy this way"
ENT.Author			= "Tomasas"

function ENT:SetupDataTables()
	self:DTVar("Entity", 0, "Player")
end