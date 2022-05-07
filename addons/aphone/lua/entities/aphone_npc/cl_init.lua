include("shared.lua")
local p_h = Vector(0,0,15)
local p = Vector(0,0,70)

function ENT:Draw()
    self:DrawModel()
    if LocalPlayer():GetPos():DistToSqr(self:GetPos()) > 500 * 500 then return end

    local ang = LocalPlayer():EyeAngles()
    local pos = self:GetPos() + p

    local targethead = self:LookupBone("ValveBiped.Bip01_Head1")

    if targethead then
        local targetheadpos = self:GetBonePosition(targethead)
        pos = targetheadpos + p_h
    end

    ang:RotateAroundAxis( ang:Forward(), 90 )
    ang:RotateAroundAxis( ang:Right(), 90 )

    cam.Start3D2D(pos, ang, 0.08)
        draw.SimpleText(self.PrintName, "Roboto80_3D", 0, -30, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    cam.End3D2D()
end

net.Receive("APhone_OpenPaint", function()
    aphone.OpenPaint()
end)