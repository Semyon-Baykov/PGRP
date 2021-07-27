surface.CreateFont( "SG.Button", { font = "Roboto", size = 16, weight = 500 } )

local PANEL = {}

function PANEL:Init()
    self.ease = FrameTime() * 8

    self.boxColor = Color( 30, 30, 30 )
    self.textColor = color_white

    self.primaryColor = color_white
    self.secondaryColor = Color( 30, 30, 30 )

    self.font = "SG.Button"
    self.text = "Button"
    self.round = 4

    self.overwroteText = false
end

function PANEL:LerpColor( oldCol, newCol )
    return Color( Lerp( self.ease, oldCol.r, newCol.r ), Lerp( self.ease, oldCol.g, newCol.g ), Lerp( self.ease, oldCol.b, newCol.b ), Lerp( self.ease, oldCol.a, newCol.a ) )
end

function PANEL:SetColor( col )
    self.boxColor = col
    self.secondaryColor = col
end

function PANEL:SetOutlineColor( col )
    self.textColor = col
    self.primaryColor = col
end

function PANEL:SetText( text )
    self.text = text
end

function PANEL:GetText()
    return self.text
end

function PANEL:SetFont( font )
    self.font = font
end

function PANEL:SetRound( num )
    self.round = num
end

function PANEL:PerformLayout()
    if !self.overwroteText then
        self:SetTextColor( Color( 0, 0, 0, 0 ) )

        self.overwroteText = true
    end
end

function PANEL:Paint( w, h )
    self.boxColor = self:LerpColor( self.boxColor, self.Hovered and self.primaryColor or self.secondaryColor )
    self.textColor = self:LerpColor( self.textColor, self.Hovered and self.secondaryColor or self.primaryColor )

    draw.RoundedBox( self.round, 0, 0, w, h, self.primaryColor )
    draw.RoundedBox( self.round, 1, 1, w - 2, h - 2, self.boxColor )

    draw.SimpleText( self.text, self.font, w / 2, h / 2, self.textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

vgui.Register( "SG_Button", PANEL, "DButton" )
