
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_junk/meathook001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	//self:SetUseType(SIMPLE_USE)
	self:GetPhysicsObject():SetMass(1)
	self:GetPhysicsObject():Wake()
	self:SetModelScale( 0.1 )
	
end

function ENT:AddFish(fish)
	if IsValid(self.Fish) then self.Fish:Remove() end
	
	self.Fish = ents.Create("prop_physics")
	self.Fish.FishID = fish
	self.Fish:SetModel(TrueFishGetFishModel(fish))
	self.Fish:PhysicsInit(SOLID_NONE)
	self.Fish:SetPos(self:GetPos() - self:GetUp()*2)
	self.Fish:SetParent(self)
	self.Fish:Spawn()
	//self.Fish:SetSolid(SOLID_NONE)
	
end

function ENT:AddMoneyBag()
	if IsValid(self.Fish) then self.Fish:Remove() end
	
	self.Fish = ents.Create("prop_physics")
	self.Fish:SetModel("models/props_c17/BriefCase001a.mdl")
	self.Fish:PhysicsInit(SOLID_NONE)
	self.Fish:SetPos(self:GetPos() - self:GetUp()*20)
	self.Fish:SetParent(self)
	self.Fish:Spawn()

end

function ENT:RemoveFish()
	if IsValid(self.Fish) then
		self.Fish:Remove()
	end
end

ENT.NextUse = 0
function ENT:Use(user, caller)
	local ctime = CurTime()
	if !IsValid(self.Fish) or ctime < self.NextUse then return end
	self.NextUse = ctime + 1
	
	local fish = self.Fish.FishID
	
	if !fish then
		TrueFishGiveMoney(caller, TrueFish.ROD_MONEYBAG_MONEY)
		TrueFishNotify(caller, TrueFishLocal("money_bag_caught", TrueFish.ROD_MONEYBAG_MONEY))
		self.Fish:Remove()
		return
	end
	
	
	caller.Fishes = caller.Fishes or {}
	if TrueFish.ROD_NO_CONTAINER then
		local playerSpace = 0
		for i=1, FISH_HIGHNUMBER do
			if caller.Fishes[i] then
				playerSpace = playerSpace + caller.Fishes[i]
			end
		end
	
		if TrueFish.FISH_CARRY_LIMIT <= playerSpace then
			TrueFishNotify(caller, TrueFishLocal("carry_limit_reached", TrueFish.FISH_CARRY_LIMIT))
			return
		end
		TrueFishNotify(caller, TrueFishLocal("fish_caught", TrueFishGetFishName(fish)))
		caller.Fishes[fish] = caller.Fishes[fish] and caller.Fishes[fish]+1 or 1
		self.Fish:Remove()
		return
	end
	
	
	local dist = {}
	local distEnt = {}
	local find = ents.FindInSphere(self:GetPos(), 250)
	for i=1, #find do
		if find[i]:IsValid() and find[i]:GetClass() == "fish_container" then
			local d = caller:GetPos():Distance(find[i]:GetPos())
			dist[#dist+1] = d
			distEnt[d] = find[i]
		end
	end
	
	if !dist[1] then
		TrueFishNotify(caller, TrueFishLocal("empty_fish_containers_near"))
		return
	end
		
	local closest 
	for k, v in SortedPairsByValue(dist) do
		closest = distEnt[v]
		if closest:GetSpace() < TrueFish.FISH_CONTAINER_LIMIT then break end
	end
	
	if !closest then return end
	
	closest:AddFish(fish, 1)
	self.Fish:Remove()
	TrueFishNotify(caller, TrueFishLocal("fish_caught", TrueFishGetFishName(fish)))
end

function ENT:Think()
	self:GetPhysicsObject():Wake()
	self:NextThink(CurTime()+1)
	return true

end

function ENT:OnRemove()
	self:RemoveFish()
end