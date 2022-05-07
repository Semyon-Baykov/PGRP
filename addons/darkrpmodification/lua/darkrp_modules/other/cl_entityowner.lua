
surface.CreateFont( 'Carshop2', {
	font = 'Arial',
	size = 17,
	weight = 400
} )



local function OpenOwnersMenu( ent )

	local f = vgui.Create( 'DFrame' )
	f:SetSize( 250, 400 )
	f:Center()
	f:SetTitle( 'Выбор владельца' )
	f:MakePopup()
	f.Paint = function( _, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )

	end
	
	local dsk = vgui.Create( 'DScrollPanel', f )
	dsk:Dock( FILL )	

	for k,v in pairs( player.GetAll() ) do
		

		local _ = vgui.Create( 'DButton', dsk )
		_:Dock( TOP )
		_:SetText( '' )
		_:SetSize( 60, 60 )
		_.ply = v
		_.Paint = function( _, w, h )

			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
			draw.RoundedBox(0,0,0,w,1,Color(0,0,0))
			draw.RoundedBox(0,0,h-1,w,1,Color(0,0,0))
			draw.RoundedBox(0,0,0,1,h,Color(0,0,0))
			draw.RoundedBox(0,w-1,0,1,h,Color(0,0,0))

			draw.SimpleText( v:Nick(), 'Carshop2', w/2, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end
		_.DoClick = function() 

			net.Start( 'gp_SetEntityOwner' )
				net.WriteEntity( _.ply )
				net.WriteEntity( ent )
			net.SendToServer()

			f:Remove()

		end


	end



end

net.Receive( 'gp_SetEntityOwner', function()

	local ent = net.ReadEntity()

	OpenOwnersMenu( ent )

end)