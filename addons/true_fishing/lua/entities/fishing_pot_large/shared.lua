
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Big Fishing Pot"
ENT.Author			= "Tomasas"


function ENT:GetSpace()
	local space = 0
	
	for i=1, FISH_HIGHNUMBER do
		if self.FishTable[i] then
			space = space + self.FishTable[i]
		end
	end
	return space
end
