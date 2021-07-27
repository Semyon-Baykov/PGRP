local PANEL = {}

function PANEL:Init()
    self.VBar:Remove()

    self.down = 0
    self.barW = 5
    self.barCol = color_white
end

function PANEL:SetColor( col )
    self.barCol = col
end

function PANEL:SetBarWidth( w )
    self.barW = w
end

function PANEL:PerformLayout( w, h )
    local w = self:GetWide()

    self:Rebuild()

    self.pnlCanvas:SetWide( w - self.barW - 1 )

    self:Rebuild()
end

function PANEL:OnMouseWheeled( delta )
    if self.pnlCanvas:GetTall() - self:GetTall() >= 0 then
        self.down = self.down - delta * 60
    end
end

function PANEL:Think()
    local h = self.pnlCanvas:GetTall()
    local x, y = self.pnlCanvas:GetPos()

    self.pnlCanvas:SetPos( 0, Lerp( FrameTime() * 8, y, -self.down ) )

    self.down = math.Clamp( self.down, 0, h - self:GetTall() )

    if h - self:GetTall() < 0 then
        self.down = 0
    end
end

function PANEL:PaintOver( w, h )
    local pH = self.pnlCanvas:GetTall()
    local x, y = self.pnlCanvas:GetPos()

    if pH - h >= 0 then
        draw.RoundedBox( 0, w - self.barW, -y / pH * h, self.barW, h * h / pH, self.barCol )
    end
end

vgui.Register( "SG_Scroll", PANEL, "DScrollPanel" )
