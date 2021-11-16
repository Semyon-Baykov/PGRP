
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Medium Fishing Pot"
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

//ENT.FishDepths = {Damselfish = 250, GoldFish = 100, Snapper = 525, Rainbow = 200, GoldenFish = 750, CatFish = 830, BassFish = 955}