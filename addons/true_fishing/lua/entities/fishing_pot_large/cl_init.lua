
include('shared.lua')

	
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:AddFish(fish)
	local pos = self:GetPos() + self:GetUp()
	local rh, fw, num = self:GetRight(), self:GetForward()*6.5, #self.FishToDisplay%14
	if num < 7 then
		num = num + 1
		self.FishToDisplay[num] = ClientsideModel(TrueFishGetFishModel(fish), RENDERGROUP_OPAQUE)
		self.FishToDisplay[num].FishID = fish
		self.FishToDisplay[num]:SetAngles(Angle(math.random(1,360), math.random(1,360), math.random(1,360)))
		self.FishToDisplay[num]:SetPos(pos - (rh*(num*5.5)+fw))
		self.FishToDisplay[num]:SetParent(self)
		self.FishToDisplay[num]:DrawShadow(false)
		self.FishToDisplay[num]:SetNoDraw(true)
	else
		num = num + 1
		self.FishToDisplay[num] = ClientsideModel(TrueFishGetFishModel(fish), RENDERGROUP_OPAQUE)
		self.FishToDisplay[num].FishID = fish
		self.FishToDisplay[num]:SetAngles(Angle(math.random(1,360), math.random(1,360), math.random(1,360)))
		self.FishToDisplay[num]:SetPos(pos + (rh*(num*5.5-45)-fw))
		self.FishToDisplay[num]:SetParent(self)
		self.FishToDisplay[num]:DrawShadow(false)
		self.FishToDisplay[num]:SetNoDraw(true)
	end
end

function ENT:AddBait()
	self.Bait = ClientsideModel("models/props_junk/garbage_bag001a.mdl", RENDERGROUP_OPAQUE)
	self.Bait:SetMaterial("models/flesh")
	local ang = self:GetAngles()
	self.Bait:SetPos(self:GetPos() + ang:Up()*15 - ang:Forward()*5)
	ang:RotateAroundAxis(ang:Right(), -90)
	self.Bait:SetAngles(ang)
	self.Bait:SetParent(self)
	self.Bait:DrawShadow(false)
	self.Bait:SetNoDraw(true)
end

function ENT:Initialize()
	self.FishToDisplay = {}
end

local cw, ccw, mat = MATERIAL_CULLMODE_CW, MATERIAL_CULLMODE_CCW,
CreateMaterial("CagePotMaterial", "VertexLitGeneric", {["$translucent"] = 1, ["$surfaceprop"] = "metal", ["$basetexture"] = "Metal/metalfence007a"})
function ENT:Draw()
	if !TrueFish.CAGE_NO_FISH_MODEL then
		for k,v in pairs(self.FishToDisplay) do
			if v:IsValid() then
				v:DrawModel()
			end
		end
	end
	if self.Bait and self.Bait:IsValid() then
		self.Bait:DrawModel()
	end

	render.MaterialOverride(mat)
	render.CullMode(cw)
	self:DrawModel()
	render.CullMode(ccw)
	self:DrawModel()
	render.MaterialOverride()	
end

ENT.DrawTranslucent = ENT.Draw

function ENT:OnRemove()
	for k,v in pairs(self.FishToDisplay) do
		v:Remove()
	end
	if self.Bait and self.Bait:IsValid() then
		self.Bait:Remove()
	end
end