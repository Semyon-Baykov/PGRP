
include('shared.lua')

	
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Draw()

	local owner = self:GetDTEntity(0)
	local Hook = self:GetDTEntity(1)
	if IsValid(Hook) then
		local pos, ang = self:GetPos(), self:GetAngles()
		local pos2, ang2 = Hook:GetPos(), Hook:GetAngles()
		render.DrawLine(pos+ang:Forward()*98 + ang:Up()*0.25, pos2+ang2:Up(), Color(255, 255, 255, 255), true)
	end
	if IsValid(owner) then
		local pos, ang = owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand", false))
		ang:RotateAroundAxis(ang:Right(), -55)
		pos = pos - ang:Forward()*6.5 + ang:Up()*1.8 + ang:Right()*1
		self:SetRenderOrigin(pos)
		self:SetRenderAngles(ang)
	end
	
	
	self:DrawModel()
end
