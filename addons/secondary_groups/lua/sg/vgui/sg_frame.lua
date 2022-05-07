surface.CreateFont( "SG.Frame", { font = "Roboto", size = ScreenScale( 10 ), weight = 500 } )

local PANEL = {}

function PANEL:Init()
    self.btnMaxim:Remove()
    self.btnMinim:Remove()
    self.btnClose:Remove()

    self.lblTitle:Hide()

    self:SetAlpha( 0 )
    self:AlphaTo( 255, .2 )

    self.blurMat = Material "pp/blurscreen"
end

function PANEL:Blur()
    local x, y = self:LocalToScreen( 0, 0 )

    DisableClipping( true )
        surface.SetMaterial( self.blurMat )
        surface.SetDrawColor( color_white )

        for i = .33, 1, .33 do
            self.blurMat:SetFloat( "$blur", i * 2.5 )
            self.blurMat:Recompute()

            render.UpdateScreenEffectTexture()

            surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
        end
    DisableClipping( false )
end

function PANEL:DrawOutlinedText( text, font, x, y, col, xAlign, yAlign )
    draw.SimpleTextOutlined( text, font, x, y, col, xAlign, yAlign, 2, Color( 0, 0, 0, 50 ) )
end

function PANEL:PerformLayout()
    self:DockPadding( 5, 5, 5, 5 )
end

function PANEL:Paint( w, h )
    self:Blur()

    DisableClipping( true )
        self:DrawOutlinedText( self.lblTitle:GetText(), "SG.Frame", w / 2, -6, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )

        draw.RoundedBox( 0, -1, -1, w + 2, h + 2, Color( 0, 178, 238 ) )
    DisableClipping( false )

    draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30 ) )
end

function PANEL:Think()
    if input.IsKeyDown( KEY_ESCAPE ) then
        self:AlphaTo( 0, .2, 0, function() self:Remove() end )

        gui.HideGameUI()
		
		for name in ipairs( hook.GetTable()[ "SG.MenuUpdate" ] ) do
			hook.Remove( "SG.MenuUpdate", name )
		end
    end
end

vgui.Register( "SG_Frame", PANEL, "DFrame" )
