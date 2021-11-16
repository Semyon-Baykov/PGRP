
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.Slashing = false
ENT.NextSplash = 0

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModelScale(0.325, 0)
	self:SetMaterial("models/props_c17/furniturefabric002a")
	
end

ENT.OnReloaded = ENT.Initialize

local lineColor = Color(255, 255, 255, 100)
function ENT:Draw()

	if !self.AnimationDone then
		if !self.RealPos then
			local owner = self:GetDTEntity(0)
			if !owner:IsValid() then return end
			local pos, ang = owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand", false))
			ang:RotateAroundAxis(ang:Right(), -55)
			ang:RotateAroundAxis(ang:Forward(), 90)
			pos = pos + ang:Forward()*91.65 + ang:Up()*1 - ang:Right()*2.1
			self.RealPos = self:GetPos()
			self.StartPos = pos
			self.LerpPercent = 0
		end
		self.LerpPercent = self.LerpPercent + FrameTime()*0.80
		local posToSet = LerpVector(self.LerpPercent, self.StartPos, self.RealPos)
		posToSet.z = posToSet.z + math.sin(self.LerpPercent*math.pi)*100
		self:SetPos(posToSet)
		
		if self.LerpPercent >= 1 then
			local pos = self.RealPos
			self:SetPos(pos)
			local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetNormal(pos)
			effectdata:SetRadius(5)
			effectdata:SetScale(5)
			util.Effect("watersplash", effectdata)
			self.AnimationDone = true
		end
	end

	if self.Slashing then
		local ctime, pos = CurTime(), self:GetPos()
		if self.NextSplash < ctime then
			local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetNormal(pos)
			effectdata:SetRadius(5)
			effectdata:SetScale(4)
			util.Effect("watersplash", effectdata)
			self.NextSplash = ctime+1
		end
		pos.z = pos.z  + math.sin(CurTime()*6)*0.05
		self:SetPos(pos)
	end

	self:DrawModel()
	
	local owner = self:GetDTEntity(0)
	if !owner:IsValid() then return end
	local pos, ang = owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand", false))
	
	ang:RotateAroundAxis(ang:Right(), -55)
	ang:RotateAroundAxis(ang:Forward(), 90)
	pos = pos + ang:Forward()*91.65 + ang:Up()*1 - ang:Right()*2.1
	local selfpos = self:GetPos()
	selfpos.z = selfpos.z + 4
	render.DrawLine(selfpos, pos, lineColor, true)
	
end
