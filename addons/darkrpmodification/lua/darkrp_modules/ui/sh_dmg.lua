if SERVER then
	util.AddNetworkString( 'NSDInfo' )
 
	hook.Add( 'EntityTakeDamage', 'SDInfo', function( ent, dmginfo )
		if not dmginfo:GetAttacker():IsPlayer() or dmginfo:GetDamage() <= 0 or not dmginfo:GetDamage() or ent:Health() <= 0 or ent == dmginfo:GetAttacker() then return end 
 
		net.Start( 'NSDInfo' )
			net.WriteUInt( dmginfo:GetDamage(), 8 )
		net.Send( dmginfo:GetAttacker() )
	end )
else
	local Alpha = 0
	local Alpha2 = 0
	local Dmg = 0
	local hide = 0
 
	surface.CreateFont( 'SDInfo', {
		font = 'Roboto',
		size = 27,
		weight = 200,
		shadow = true
	} )
 
	net.Receive( 'NSDInfo', function( len, ply ) 
		if Alpha2 > 40 then
			Dmg = Dmg + net.ReadUInt( 8 )	
		else
			Dmg = net.ReadUInt( 8 )	
		end

		Alpha = 255
		Alpha2 = 255
		hide = 0
 
		LocalPlayer():EmitSound( 'damage/hitmarker.wav', 500, 100, 1 )

		timer.Simple( 2, function() hide = 1 end )
	end )
 
	local texture = Material( 'data/cherep.png' )
 
	hook.Add( 'HUDPaint', 'SDInfo', function()
		if not Dmg then return end
 
		draw.SimpleTextOutlined( tostring( Dmg ), 'SDInfo', ScrW() / 2, ScrH() / 2.15, Color( 225, 40, 0, Alpha2 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, Alpha ) )
 		
		local screen = Vector( ScrW() / 2, ScrH() / 2 )

		local sz = 13

		surface.SetDrawColor( 255, 255, 255, Alpha )
		surface.DrawLine( screen.x - sz, screen.y - sz, screen.x - 5, screen.y - 5 )
		surface.SetDrawColor( 255, 255, 255, Alpha )
		surface.DrawLine( screen.x - sz, screen.y + sz, screen.x - 5, screen.y + 5 )
		surface.SetDrawColor( 255, 255, 255, Alpha )
		surface.DrawLine( screen.x + sz, screen.y - sz, screen.x + 5, screen.y - 5 )
		surface.SetDrawColor( 255, 255, 255, Alpha )
		surface.DrawLine( screen.x + sz, screen.y + sz, screen.x + 5, screen.y + 5 )
		surface.SetDrawColor( 255, 255, 255, Alpha )

		if hide then
			Alpha = Alpha - 5
			Alpha2 = Alpha2 - 2
		end
	end )
end