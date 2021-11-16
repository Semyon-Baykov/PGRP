include( "shared.lua" )

function ENT:Initialize()
end

local mat_firetruck = Material( "materials/craphead_scripts/fire_system/firetruck.png", "noclamp smooth" )
local col_bg = Color( 30, 30, 30, 240 )
local col_orange = Color( 255, 165, 51, 255 )

function ENT:Draw()
	self:DrawModel()
	
	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) >= CH_FireSystem.Config.DistanceTo3D2D then
		return
	end
	
	if CH_FireSystem.Config.OverheadTextDisplay then
		local Ang = self:GetAngles()
		local AngEyes = LocalPlayer():EyeAngles()

		Ang:RotateAroundAxis( Ang:Forward(), 90 )
		Ang:RotateAroundAxis( Ang:Right(), -90 )
		
		cam.Start3D2D( self:GetPos() + self:GetUp() * 85, Angle( 0, AngEyes.y - 90, 90 ), 0.04 )
			draw.RoundedBox( 12, -270, 0, 560, 200, col_bg )

			-- Draw crate of crops
			surface.SetDrawColor( color_white )
			surface.SetMaterial( mat_firetruck )
			surface.DrawTexturedRect( -260, 0, 210, 210 )
			
			draw.SimpleText( CH_FireSystem.Config.NPCDisplayName, "FIRE_ExtCabinet", -40, 40, col_orange, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( CH_FireSystem.Config.NPCDisplayDescription, "FIRE_UIFontTitle", -40, 90, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		cam.End3D2D()
	end
end