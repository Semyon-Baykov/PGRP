surface.CreateFont( 'AnimationMenu', {

    font = 'ScoreboardHeader',

    size = 17,

    weight = 400

} )

surface.CreateFont( 'AnimationMenu_mini', {

    font = 'ScoreboardHeader',

    size = 15,

    weight = 400
    
} )

local blur = Material( 'pp/blurscreen' )

local blurffect = function( panel, layers, density, alpha )
	local x, y = panel:LocalToScreen( 0, 0 )

	surface.SetDrawColor( Color( 255, 255, 255, alpha) )
	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( '$blur', ( i / layers) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end
end

local AnimFrame = nil 

local function AnimationMenu()

	if AnimFrame and IsValid( AnimFrame ) then return end

	local ClickPanel = vgui.Create( 'Panel' )

	ClickPanel:SetPos( 0, 0 )

	ClickPanel:SetSize( ScrW(), ScrH() )

	ClickPanel.OnMousePressed = function()

		AnimFrame:Close()

	end

		
	local height = table.Count( DRP_Animations ) * 55 + 32

	AnimFrame = AnimFrame or vgui.Create( 'DFrame' )

	AnimFrame:SetSize( 130, height )

	AnimFrame:SetPos( ScrW() / 2 + ScrW() * 0.1, ScrH() / 2 - ( height / 2 ) )

	AnimFrame:SetTitle( DarkRP.getPhrase( 'custom_animation' ) )

	AnimFrame:ShowCloseButton( false )

	AnimFrame:MakePopup()

	AnimFrame:SetKeyboardInputEnabled( false )

	AnimFrame.Paint = function( self, w, h )

        blurffect( self, 5, 10, 255 )

        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 150 ) )

        draw.RoundedBox( 0, 0, 0, w, 21, Color( 0, 0, 0, 150 ) )

    end

    AnimFrame.Close = function( self )

        ClickPanel:Remove()

        AnimFrame:Remove()

        AnimFrame = nil

    end

    local closebutton = vgui.Create( 'DButton', AnimFrame )

    closebutton:SetSize( ( ScrW() - ( ScrW() / 1.20 ) ) / 8, 15 )

    closebutton:SetPos( AnimFrame:GetWide() - closebutton:GetWide() - 3, 3 )

    closebutton:SetText( '' ) 

    closebutton:SetColor( Color( 182, 35, 29 ) )

    closebutton.Paint = function( self, w, h )

        draw.RoundedBox( 2, 0, 0, w, h, Color( 152, 25, 29 ) )

        draw.SimpleText( '✕', 'AnimationMenu', w / 2, h / 2.25, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    end

    closebutton.DoClick = function()

    	AnimFrame:Close()

    end

    local i = 0

    for k,v in SortedPairs( DRP_Animations ) do

        i = i + 1

        local button = vgui.Create("DButton", AnimFrame)

        button:SetPos( 10, ( i - 1 ) * 55 + 30 )

        button:SetSize( 110, 50 )

        button:SetText( '' )

        button.OnCursorEntered = function( self ) self.hover = true end

		button.OnCursorExited = function( self ) self.hover = false end

        button.Paint = function( self, w, h )

        	draw.RoundedBox( 0, 0, 0, w, h,  Color( 0, 0, 0, 175 ) )

			if self.hover then

				draw.RoundedBox( 0, 0, 0, w, h,  Color( 255, 255, 255, 5 ) )

			end

			draw.SimpleText( v, 'AnimationMenu_mini', w / 2, h / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    	end

        button.DoClick = function()

            RunConsoleCommand( '_DarkRP_DoAnimation' , k )

        end
    end

end

concommand.Add( '_DarkRP_AnimationMenu' , AnimationMenu )

