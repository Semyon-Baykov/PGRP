
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

util.AddNetworkString("MediumPotMenu")
util.AddNetworkString("m_p_deploy")
util.AddNetworkString("m_p_hook")
util.AddNetworkString("m_p_collect")
util.AddNetworkString("FishPotUpdate")

function ENT:Initialize()	
	self:SetModel("models/props_junk/wood_crate002a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetPos(self:GetPos()+Vector(0, 0, 40.500))
	local phys = self:GetPhysicsObject()    
	if phys:IsValid() then
		self.BuoyancyRatio = 0.1
		phys:SetBuoyancyRatio(0.1)
		phys:Wake()
	end
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(false)
	self.Deployed = false
	self.FishTable = {}
	self.IsHookedToEntity = false
	self.NeedsBait = true

end

function ENT:Use(activator, caller)
	if (!caller:IsValid() or !caller:IsPlayer()) then return end	
	local tracedata, pos = {}, self:GetPos()
	tracedata.start = pos
	tracedata.endpos = pos-Vector(0, 0, 90)
	tracedata.filter = self
	local trace = util.TraceLine(tracedata)
	
	net.Start("MediumPotMenu")
	net.WriteEntity(self)
	net.WriteEntity(NULL)
	net.WriteBit(self.Deployed)
	net.WriteBit(!self.IsHookedToEntity and trace.Hit and !trace.HitWorld and trace.Entity:IsValid())
	net.WriteBit(self.IsHookedToEntity)
	net.WriteBit(self:GetSpace() != 0)
	net.WriteBit(self.NeedsBait)
	net.Send(caller)
	
end

local allowedToWeld = {fishing_pot_medium = true, fishing_pot_large = true, fish_container = true}
local function WeldWithEntity(len, ply)
	local ent = net.ReadEntity()
	if !ent:IsValid() or !allowedToWeld[ent:GetClass()] or ent:GetPos():Distance(ply:GetPos()) > 150 then return end

	if ent.IsHookedToEntity then
		constraint.RemoveConstraints(ent, "Weld")
		ent.IsHookedToEntity = false
		return
	end
	
	local tracedata, pos = {}, ent:GetPos()
	tracedata.start = pos
	tracedata.endpos = pos-Vector(0, 0, 90)
	tracedata.filter = ent
	local trace = util.TraceLine(tracedata)
	if trace.Hit and trace.Entity:IsValid() then
		constraint.Weld(trace.Entity, ent, 0, 0, 0, true)
		ent.IsHookedToEntity = true
	end

end
net.Receive("m_p_hook", WeldWithEntity)

local function DeployPot(len, ply)
	local ent = net.ReadEntity()
	if !ent:IsValid() or ent.Deployed or ent:GetPos():Distance(ply:GetPos()) > 150 or ent.NeedsBait then return end
	
	ent:Deploy(ply)
end
net.Receive("m_p_deploy", DeployPot)

function ENT:Deploy(ply)
	local pos = self:GetPos()
	if util.PointContents(pos-Vector(0, 0, 35)) != 268435488 then
		TrueFishNotify(ply, TrueFishLocal("no_water_detected"))
		return
	end
	
	
	constraint.RemoveConstraints(self, "Weld")
	self.IsHookedToEntity = false
	

	self.Ball1 = ents.Create("ent_buoy")
	self.Ball1:SetModel("models/xqm/rails/gumball_1.mdl")
	self.Ball1:SetMaterial("models/props_c17/furniturefabric002a")
	self.Ball1:SetPos(pos+Vector(0, 0, 140))
	self.Ball1.IsBuoy = self
	self.Ball1.MediumBuoy = true
	self.Ball1:Spawn()
	
	local phys = self.Ball1:GetPhysicsObject()
	if phys:IsValid() then
		self.Ball1.BuoyancyRatio = 0.68
		phys:SetBuoyancyRatio(0.68)
		phys:SetDamping(1, 1)
		phys:Wake()
	end
	phys = self:GetPhysicsObject()
	phys:SetDamping(1, 1)
	self.BuoyancyRatio = 0.01
	phys:SetBuoyancyRatio(0.01)
	
	if !TrueFish.OPTIMIZED_FISHING then
		local tracedata = {}
		pos.z = pos.z+35
		tracedata.start = pos
		tracedata.endpos = pos-Vector(0, 0, FISH_MAX_DEPTH)
		tracedata.mask = MASK_OPAQUE
		local trace = util.TraceLine(tracedata)
		if !trace.Hit then	
			local constraint, rope = constraint.Rope(self, self.Ball1, 0, 0, Vector(0, 0, 20), Vector(0, 0, 0), FISH_MAX_DEPTH, 0, 0, 2.7, "cable/cable2", false)
			self.Depth = FISH_MAX_DEPTH
		else
			self.Depth = math.Clamp(math.abs(trace.HitPos.z - pos.z), 35, FISH_MAX_DEPTH)
			local constraint, rope = constraint.Rope(self, self.Ball1, 0, 0, Vector(0, 0, 20), Vector(0, 0, 0), self.Depth*0.95, 0, 0, 2.7, "cable/cable2", false)
		end
	
	else
		self.Ball1:GetPhysicsObject():EnableMotion(false)
		phys:EnableMotion(false)
	
		local tracedata = {}
		pos.z = pos.z+75
		tracedata.start = pos
		tracedata.endpos = pos-Vector(0, 0, 200)
		tracedata.mask = 268435488
		local trace = util.TraceLine(tracedata) // find surface
		if !trace.Hit then	
			TrueFishNotify(ply, TrueFishLocal("cant_find_water_surface"))
			self.NeedsBait = false
			local phys = self:GetPhysicsObject()
			self.BuoyancyRatio = 0.1
			phys:SetBuoyancyRatio(0.1)
			return
		else
			tracedata.start = trace.HitPos
			tracedata.endpos = trace.HitPos-Vector(0, 0, FISH_MAX_DEPTH)
			tracedata.mask = MASK_OPAQUE
			local trace2 = util.TraceLine(tracedata)
			trace2.HitPos.z = trace2.HitPos.z or trace.HitPos.z - FISH_MAX_DEPTH
			self.Depth = math.Clamp(math.abs(trace2.HitPos.z - trace.HitPos.z), 35, FISH_MAX_DEPTH)
			
			if (self.Depth < 55) then
				TrueFishNotify(ply, TrueFishLocal("water_surface_shallow"))
				self.Ball1:Remove()
				self.NeedsBait = false
				local phys = self:GetPhysicsObject()
				self.BuoyancyRatio = 0.1
				phys:SetBuoyancyRatio(0.1)
				phys:EnableMotion(true)
				return
			end
			trace2.HitPos.z = trace2.HitPos.z + 30
			self:SetPos(trace2.HitPos)
			trace.HitPos.z = trace.HitPos.z - 1.5
			self.Ball1:SetPos(trace.HitPos)
			local constraint, rope = constraint.Rope(self, self.Ball1, 0, 0, Vector(0, 0, 20), Vector(0, 0, 0), self.Depth*0.95, 0, 0, 2.7, "cable/cable2", false)
		end
	
	end
	
	self.Deployed = true
	local fish = TrueFishCalculateFish(self.Depth)
	self:NextThink(CurTime()+(fish and math.random(TrueFish.FISH_CATCH_TIME[fish][1], TrueFish.FISH_CATCH_TIME[fish][2]) or 5))
	self.FishTries = 0
	
	if self.Depth < 60 then
		local diff = 60 - self.Depth
		local pos = self.Ball1:GetPos()
		pos.z = pos.z + diff
		self.Ball1:SetPos(pos)
	end
	
	
end

function ENT:Undeploy()
	self.Deployed = false
	self.NeedsBait = true
	
	self:SetPos(self.Ball1:GetPos())
	local phys = self:GetPhysicsObject()
	self.BuoyancyRatio = 0.1
	phys:SetBuoyancyRatio(0.1)
	phys:EnableMotion(true)
	
	if self.Ball1:IsValid() then
		self.Ball1:Remove()
	end
	
end

function ENT:CatchFish()
	local fish = TrueFishCalculateFish(self.Depth)
	
	if math.random(1000) <= TrueFish.MEDIUM_JUNK_CHANCE then
		fish = FISH_JUNK
	end
	
	if !fish or self:GetSpace() >= TrueFish.MEDIUM_CAGE_FISH_LIMIT then
		self:NextThink(CurTime()+15)
		//print("No fish at "..self.Depth)
		return
	end
	
	local nextCatch = TrueFish.FISH_CATCH_TIME[fish] and math.random(TrueFish.FISH_CATCH_TIME[fish][1], TrueFish.FISH_CATCH_TIME[fish][2]) or 5
	self:NextThink(CurTime() + nextCatch)
	
	self.FishTable[fish] = self.FishTable[fish] and self.FishTable[fish]+1 or 1
	
	local players = player.GetAll()
	if self:GetSpace() == TrueFish.MEDIUM_CAGE_FISH_LIMIT then
		self.NeedsBait = true
		net.Start("FishPotUpdate")
		net.WriteEntity(self)
		net.WriteUInt(3, 2)
		net.Send(players)
		if TrueFish.CAGE_BUOY_SPLASHING then
			net.Start("BuoySplash")
			net.WriteEntity(self.Ball1)
			net.Send(players)
		end
	end
	net.Start("FishPotUpdate")
	net.WriteEntity(self)
	net.WriteUInt(0, 2)
	net.WriteUInt(fish, 6)
	net.Send(players)
end

function ENT:Think()
	if self:WaterLevel() < 2 then
		self:NextThink(CurTime() + 3)
		return true
	end
	if self.Deployed then
	
		local tracedata = {}
		tracedata.start = self.Ball1:GetPos()
		tracedata.endpos = tracedata.start-Vector(0, 0, FISH_MAX_DEPTH)
		tracedata.mask = MASK_OPAQUE
		local trace = util.TraceLine(tracedata)
		self.Depth = !trace.HitPos and FISH_MAX_DEPTH or math.Clamp(math.abs(trace.HitPos.z - tracedata.start.z), 35, FISH_MAX_DEPTH)
		
		self:CatchFish()
	end
	
	return true
end

local function CollectFish(len, ply)
	local ent = net.ReadEntity()
	if !ent:IsValid() or ent.Deployed or ent:GetPos():Distance(ply:GetPos()) > 150 then return end
	
	if TrueFish.CONTAINERS_DISABLED then
		ply.Fishes = ply.Fishes or {}
		
		local fishCount = 0
		for i=1, FISH_HIGHNUMBER do
			if ply.Fishes[i] then
				fishCount = fishCount + ply.Fishes[i]
			end
		end
		if TrueFish.FISH_CARRY_LIMIT <= fishCount then
			TrueFishNotify(ply, TrueFishLocal("carry_limit_reached", TrueFish.FISH_CARRY_LIMIT))
			return
		end
		
		for i=1, FISH_HIGHNUMBER do
			local potFish = ent.FishTable[i]
			if potFish and potFish > 0 then
				local contFish = 0
				for i=1, FISH_HIGHNUMBER do
					if ply.Fishes[i] then
						contFish = contFish + ply.Fishes[i]
					end
				end
				
				local canTake = contFish + potFish - TrueFish.FISH_CARRY_LIMIT
				canTake = canTake >= 0 and ent.FishTable[i]-canTake or ent.FishTable[i]
				ent.FishTable[i] = ent.FishTable[i] - canTake
				ply.Fishes[i] = ply.Fishes[i] and ply.Fishes[i] + canTake or canTake

			end
		end
		return
	end
	
	
	local dist = {}
	local distEnt = {}
	local find = ents.FindInSphere(ent:GetPos(), 250)
	for i=1, #find do
		if find[i]:IsValid() and find[i]:GetClass() == "fish_container" then
			local d = ent:GetPos():Distance(find[i]:GetPos())
			dist[#dist+1] = d
			distEnt[d] = find[i]
		end
	end
	
	if !dist[1] then
		TrueFishNotify(ply, TrueFishLocal("no_fish_containers_near"))
		return
	end
		
	local closest 
	for k, v in SortedPairsByValue(dist) do
		if distEnt[v]:GetSpace() < TrueFish.FISH_CONTAINER_LIMIT then
			closest = distEnt[v]
			break
		end
	end
	
	if !closest then
		TrueFishNotify(ply, TrueFishLocal("fish_containers_full"))
		return
	end

	net.Start("FishPotUpdate")
	net.WriteEntity(ent)
	net.WriteUInt(1, 2)
	
	for i=1, FISH_HIGHNUMBER do
		local potFish = ent.FishTable[i]
		if potFish and potFish > 0 then
			local contFish = closest:GetSpace()
			local canTake = contFish + potFish - TrueFish.FISH_CONTAINER_LIMIT
			canTake = canTake >= 0 and ent.FishTable[i]-canTake or ent.FishTable[i]

			ent.FishTable[i] = ent.FishTable[i] - canTake
			closest:AddFish(i, canTake, true)
			net.WriteUInt(i, 6)
			net.WriteUInt(canTake, 8)
		end
	end
	net.WriteUInt(0, 6)
	net.Broadcast()
	closest:UpdateFishes()
	
end
net.Receive("m_p_collect", CollectFish)

function ENT:OnRemove()

	local owner = self.Owner
	if owner:IsValid() then
		if TrueFish.CAGE_SHARED_LIMIT then
			owner.FishingEquipment = owner.FishingEquipment - 1
		else
			owner.MediumFishingPot = owner.MediumFishingPot - 1
		end
	end

	if self.Deployed and self.Ball1:IsValid() then
		self.Ball1:Remove()
	end
end