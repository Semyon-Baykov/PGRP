include( "shared.lua" )

local col_bg = Color( 20, 20, 20, 220 )
local col_text = Color( 200, 200, 200, 220 )

net.Receive( "CH_FIRE_ExtCabinet_StartCooldown", function( length, ply )
	local countdown_time = net.ReadUInt( 10 )
	local ent = net.ReadEntity()
	
	ent.CooldownTime = CurTime() + countdown_time
end )

function ENT:DrawTranslucent()
	self:DrawModel()
	
	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > CH_FireSystem.Config.DistanceTo3D2D then
		return
	end

	-- The front panel
	local Pos = self:GetPos() + Vector( 0, 0, 10 )
	local Ang = self:GetAngles()

	Ang:RotateAroundAxis( Ang:Forward(), 90 )
	Ang:RotateAroundAxis( Ang:Right(), -90 )

	cam.Start3D2D( Pos + Ang:Up() * 4.5, Ang, 0.02 )
		draw.RoundedBox( 6, -125, 465, 250, 70, col_bg  )
		
		if self.CooldownTime and self.CooldownTime > CurTime() then
			draw.SimpleText( string.ToMinutesSeconds( math.Round( self.CooldownTime - CurTime() ) ), "FIRE_ExtCabinet", 0, 470, col_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2 )
		else
			draw.SimpleText( CH_FireSystem.Config.Lang["Take Ext."][CH_FireSystem.Config.Language], "FIRE_ExtCabinet", 0, 470, col_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2 )
		end
	cam.End3D2D()
end