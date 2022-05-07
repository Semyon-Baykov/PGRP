local PANEL = {}

function PANEL:Init()
    self.oldOpen = self.OpenMenu
    self.childCount = 0

    self.overwroteOpening = false
end

function PANEL:SetChildCount( num )
    self.childCount = num
end

function PANEL:PerformLayout()
    self.DropButton:SetSize( 15, 15 )
    self.DropButton:AlignRight( 4 )
    self.DropButton:CenterVertical()

    if !self.overwroteOpening then
        self.overwroteOpening = true

        self:SetFont "SG.Button"
        self:SetTextColor( color_white )

        self.oldOpen = self.OpenMenu

        self.OpenMenu = function( s )
            self.oldOpen( s )

            self.Menu.Paint = function( s, w, h )
                draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 178, 238 ) )
                draw.RoundedBox( 0, 1, 1, w - 2, h - 2, Color( 30, 30, 30 ) )
            end

            for i = 1, self.childCount do
                local child = self.Menu:GetChild( i )

                child:SetFont "SG.Button"
                child:SetTextColor( color_white )
            end
        end
    end
end

function PANEL:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 178, 238 ) )
    draw.RoundedBox( 0, 1, 1, w - 2, h - 2, Color( 30, 30, 30 ) )
end

vgui.Register( "SG_ComboBox", PANEL, "DComboBox" )
