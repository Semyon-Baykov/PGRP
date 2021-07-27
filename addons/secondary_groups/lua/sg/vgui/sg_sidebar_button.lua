surface.CreateFont( "SG.SidebarButton", { font = "Roboto", size = ScreenScale( 6 ), weight = 500 } )

local PANEL = {}

function PANEL:Init()
    self.baseCol = Color( 30, 30, 30 )
    self.accentCol = Color( 0, 178, 238 )
    self.textCol = color_white

    self.originalCol = self.textCol

    self.w = 0
    self.isSelected = false
    self.isActive = false

    self.text = "Button"
    self.font = "SG.SidebarButton"

    self.panel = nil

    self.overwroteText = false

    self.ease = FrameTime() * 10
end

function PANEL:LerpColor( oldCol, newCol )
    return Color( Lerp( self.ease, oldCol.r, newCol.r ), Lerp( self.ease, oldCol.g, newCol.g ), Lerp( self.ease, oldCol.b, newCol.b ), Lerp( self.ease, oldCol.a, newCol.a ) )
end

function PANEL:SetColor( col )
    self.textCol = col
end

function PANEL:SetBaseColor( col )
    self.baseCol = col
end

function PANEL:SetAccentColor( col )
    self.accentCol = col
end

function PANEL:SetText( text )
    self.text = text
end

function PANEL:SetActive( bool )
    self.isActive = bool
end

function PANEL:SetSelected( bool )
    self.isSelected = bool
end

function PANEL:SetEase( ease )
    self.ease = ease
end

function PANEL:SetPanel( panel )
    self.panel = panel
end

function PANEL:PerformLayout()
    if !self.overwroteText then
        self:SetTextColor( Color( 0, 0, 0, 0 ) )

        self.overwroteText = true
    end
end

function PANEL:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, self.w, h - 1, self.baseCol )

    if math.Round( self.w ) > 1 then
        draw.RoundedBox( 0, 0, h - 1, math.Round( self.w ), 1, self.accentCol  )
        draw.RoundedBox( 0, w - math.Round( self.w ), h - 1, math.Round( self.w ), 1, self.accentCol )
    end

    draw.RoundedBox( 0, 0, 0, w, h - 1, self.baseCol )

    draw.SimpleText( self.text, self.font, w / 2, h / 2, self.textCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    if self.isSelected and self.isActive then
        self.textCol = self:LerpColor( self.textCol, self.accentCol )
        self.w = Lerp( self.ease, self.w, w / 2 + 4 )
    end

    if !self.isActive then
        self.textCol = self:LerpColor( self.textCol, self.originalCol )
        self.w = Lerp( self.ease, self.w, 0 )

        if math.Round( self.w ) == 0 then
            self.isSelected = false
        end
    end
end

vgui.Register( "SG_Sidebar_Button", PANEL, "DButton" )
