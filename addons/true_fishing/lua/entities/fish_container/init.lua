
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

util.AddNetworkString("SendFish")
util.AddNetworkString("FishMenu")
util.AddNetworkString("DiscardFish")
util.AddNetworkString("SendFishSpawn")

hook.Add("PlayerAuthed", "SendFishContainers", function(ply)
	timer.Simple(20, function()
		if !ply:IsValid() then return end
		local ent = ents.FindByClass("fish_container")
		net.Start("SendFishSpawn")
		net.WriteUInt(#ent, 13)
		for k, v in pairs(ent) do
			net.WriteUInt(v:EntIndex(), 13)
			for i=1, FISH_HIGHNUMBER do
				if v.Fishes[i] and v.Fishes[i] > 0 then
					net.WriteUInt(i, 6)
					net.WriteUInt(v.Fishes[i], 8)
				end
			end
			net.WriteUInt(0, 6)
		end
		net.Send(ply)
	end)
end)


net.Receive("DiscardFish", function(len, ply)
	local ent, fish = net.ReadEntity(), net.ReadInt(16)
	if !ent:IsValid() or !ent.Fishes[fish] or !ent.Owner == ply or ent:GetPos():Distance(ply:GetPos()) > 200 then return end
	
	ent.Fishes[fish] = nil
	ent:UpdateFishes()
	
end)

local meta = FindMetaTable("Player")// slight hack for updating vars to the client - darkrp doesn't include hooks for dropPocketItem
local c_dropPocketItem = meta.dropPocketItem
function meta:dropPocketItem(item)
	local ent = c_dropPocketItem(self, item)
	
	
	if !ent or !ent:IsValid() or ent:GetClass() != "fish_container" or #ent.Fishes < 1 then return end
	
	timer.Simple(0.5, function()
		if !ent:IsValid() then return end
		ent:UpdateFishes()
	end)
	
	return ent
end
meta = nil


function ENT:AddFish(num, size, noNet)
	self.Fishes[num] = self.Fishes[num] and self.Fishes[num] + size or size//realSize or realSize
	
	if noNet then return end
	self:UpdateFishes()
end

function ENT:UpdateFishes()
	net.Start("SendFish")
	net.WriteUInt(self:EntIndex(), 13)
	for i=1, FISH_HIGHNUMBER do
		if self.Fishes[i] and self.Fishes[i] > 0 then
			net.WriteUInt(i, 6)
			net.WriteUInt(self.Fishes[i], 8)
		end
	end
	net.WriteUInt(0, 6)
	net.Broadcast()
end

function ENT:Initialize()	
	self:SetModel("models/props_junk/cardboard_box001a.mdl")
	self:SetMaterial("phoenix_storms/bluemetal")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetPos(self:GetPos()+Vector(0, 0, 40))
	local phys = self:GetPhysicsObject()    
	self.BuoyancyRatio = 0.175
	phys:SetBuoyancyRatio(0.175)
	phys:Wake()
	//self:SetAngles(self:GetAngles()+Angle(0, 0, 180))
	self:SetUseType(SIMPLE_USE)
	self.Fishes = {}
	
end

function ENT:Use(activator, caller)
	if (!caller:IsValid() or !caller:IsPlayer()) then return end	
	
	local tracedata, pos = {}, self:GetPos()
	tracedata.start = pos
	tracedata.endpos = pos-Vector(0, 0, 90)
	tracedata.filter = self
	local trace = util.TraceLine(tracedata)
	
	net.Start("FishMenu")
	net.WriteEntity(self)
	net.WriteBit(!self.IsHookedToEntity and trace.Hit and !trace.HitWorld and trace.Entity:IsValid())
	net.WriteBit(self.IsHookedToEntity)
	net.WriteBit(TrueFish.FISH_CONTAINER_OWNER_DISCARD and caller == self.Owner or !TrueFish.FISH_CONTAINER_OWNER_DISCARD)
	net.Send(caller)
end

function ENT:OnRemove()
	if self.Owner and self.Owner:IsValid() then
		self.Owner.FishContainers = self.Owner.FishContainers-1
	end
end
