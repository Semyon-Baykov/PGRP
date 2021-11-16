
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Fish Container"
ENT.Author			= "Tomasas"

function ENT:GetSpace()
	local space = 0
	
	if self.Fishes && type(self.Fishes) == "table" then
		for i=1, FISH_HIGHNUMBER do
			if self.Fishes[i] then
				space = space + self.Fishes[i]
			end
		end
	end
	return space
end