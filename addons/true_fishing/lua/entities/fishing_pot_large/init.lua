
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()	
	self:SetModel("models/hunter/blocks/cube075x2x1.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetPos(self:GetPos()+Vector(0, 0, 40.500))
	local phys = self:GetPhysicsObject()    
	if phys:IsValid() then
		self.BuoyancyRatio = 0.11
		phys:SetBuoyancyRatio(0.11)
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
		self.Ball1.BuoyancyRatio = 0.8
		phys:SetBuoyancyRatio(0.8)
		phys:SetDamping(1, 1)
		phys:Wake()
	end
	phys = self:GetPhysicsObject()
	phys:SetDamping(1, 1)
	self.BuoyancyRatio = 0.011
	phys:SetBuoyancyRatio(0.011)
	
	if !TrueFish.OPTIMIZED_FISHING then
		local tracedata = {}
		pos.z = pos.z+35
		tracedata.start = pos
		tracedata.endpos = pos-Vector(0, 0, FISH_MAX_DEPTH)
		tracedata.mask = MASK_OPAQUE
		local trace = util.TraceLine(tracedata)
		if !trace.Hit then	
			local constraint, rope = constraint.Rope(self, self.Ball1, 0, 0, Vector(-5, 0, 23.5), Vector(0, 0, 0), FISH_MAX_DEPTH, 0, 0, 2.7, "cable/cable2", false)
			self.Depth = FISH_MAX_DEPTH
		else
			self.Depth = math.Clamp(math.abs(trace.HitPos.z - pos.z), 35, FISH_MAX_DEPTH)
			local constraint, rope = constraint.Rope(self, self.Ball1, 0, 0, Vector(-5, 0, 23.5), Vector(0, 0, 0), self.Depth*0.95, 0, 0, 2.7, "cable/cable2", false)
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
			self.Ball1:Remove()
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
				self.BuoyancyRatio = 0.11
				phys:SetBuoyancyRatio(0.11)
				phys:EnableMotion(true)
				return
			end
			
			trace2.HitPos.z = trace2.HitPos.z + 30
			self:SetPos(trace2.HitPos)
			trace.HitPos.z = trace.HitPos.z - 1.5
			self.Ball1:SetPos(trace.HitPos)
			local constraint, rope = constraint.Rope(self, self.Ball1, 0, 0, Vector(-5, 0, 23.5), Vector(0, 0, 0), self.Depth*0.95, 0, 0, 2.7, "cable/cable2", false)
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
	self.BuoyancyRatio = 0.11
	phys:SetBuoyancyRatio(0.11)
	phys:EnableMotion(true)
	
	if self.Ball1:IsValid() then
		self.Ball1:Remove()
	end
	
end

function ENT:CatchFish()
	local fish = TrueFishCalculateFish(self.Depth)
	
	if math.random(1000) <= TrueFish.LARGE_JUNK_CHANCE then
		fish = FISH_JUNK
	end
	
	if !fish or self:GetSpace() >= TrueFish.LARGE_CAGE_FISH_LIMIT then
		self:NextThink(CurTime()+15)
		//print("No fish at "..self.Depth)
		return
	end
	
	local nextCatch = TrueFish.FISH_CATCH_TIME[fish] and math.random(TrueFish.FISH_CATCH_TIME[fish][1], TrueFish.FISH_CATCH_TIME[fish][2]) or 5
	self:NextThink(CurTime() + nextCatch)
	
	self.FishTable[fish] = self.FishTable[fish] and self.FishTable[fish]+1 or 1
	
	local players = player.GetAll()
	if self:GetSpace() == TrueFish.LARGE_CAGE_FISH_LIMIT then
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

function ENT:OnRemove()

	local owner = self.Owner
	if owner:IsValid() then
		if TrueFish.CAGE_SHARED_LIMIT then
			owner.FishingEquipment = owner.FishingEquipment - 1
		else
			owner.LargeFishingPot = owner.LargeFishingPot - 1
		end
	end

	if self.Deployed and self.Ball1:IsValid() then
		self.Ball1:Remove()
	end
end

// 9e371d7e3672c78ecc26a47f79f3404762a07a781b05ba98291ac3950ed14f7c