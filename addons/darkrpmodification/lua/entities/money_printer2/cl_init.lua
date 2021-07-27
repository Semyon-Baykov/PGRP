include("shared.lua")

function ENT:Initialize()
    self:initVars()
    if not self.DisplayName or self.DisplayName == "" then
        self.DisplayName = DarkRP.getPhrase("money_printer")
    end

end

function ENT:Draw()
    self:DrawModel()
    self.info = util.JSONToTable( self:GetNWString( 'gp_mp.info', '{}' ) )
    local Pos = self:GetPos()
    local Ang = self:GetAngles()

    surface.SetFont("HUDNumber5")
    local text = self.DisplayName
    local TextWidth = surface.GetTextSize(text)

    Ang:RotateAroundAxis(Ang:Up(), 90)

    cam.Start3D2D(Vector(Pos.x, Pos.y, Pos.z) + Ang:Up() * 11.5, Ang, 0.1)
        draw.SimpleTextOutlined('Денежный принтер', 'Trebuchet24', 10, -20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
        if self.info.arrested then
            draw.SimpleTextOutlined('Арестован', 'Trebuchet24', 10, 0, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
        elseif self.info.broken then
            draw.SimpleTextOutlined('Сломан', 'Trebuchet24', 10, 0, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
      else 
            draw.SimpleTextOutlined(DarkRP.formatMoney(self.info.cash), 'Trebuchet24', 10, 0, Color( 108, 198, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
        end
    cam.End3D2D()
end

function ENT:Think()
end
