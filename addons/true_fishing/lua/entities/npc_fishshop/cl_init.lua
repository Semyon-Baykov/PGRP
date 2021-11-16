
ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.Author = "Tomasas"

function ENT:Draw()
	self:DrawModel()
	
	local plypos, pos = LocalPlayer():GetPos(), self:GetPos()
	pos.z = pos.z + 76
	local faceplant = (plypos-pos):Angle()
	faceplant.p = 180
	faceplant.y = faceplant.y-90
	faceplant.r = faceplant.r-90
	cam.Start3D2D(pos, faceplant, 0.1)
		draw.SimpleText(TrueFishLocal("fisherman"), "SegoeUI_NormalBold_60", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end
