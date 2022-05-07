module( 'derma_notify', package.seeall )

tbl = {
	[1] = 'cross',
	[2] = 'success'
}

surface.CreateFont( 'notify.title', {
	font = 'Roboto',
	size = 33,
	extended = false,
} )
surface.CreateFont( 'notify.text', {
	font = 'Roboto',
	size = 20,
	extended = false,
} )


function notify( id, title, text )

	local panel = vgui.Create( 'EditablePanel' )
	panel:SetSize( ScrW()/4, ScrH()/2.5 )
	panel:Center()
	panel:MakePopup()
	panel.Paint = function( _, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( color_cgray.r, color_cgray.g, color_cgray.b, 255 ) )

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( Material( 'ui/'..tbl[id]..'.png' ) )
		surface.DrawTexturedRect( w/2-64, 25, 128, 128 )

		draw.SimpleText( title, 'notify.title', w/2, h/2+30, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
		draw.DrawText( text, 'notify.text', w/2, h/2+60, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	

	end

	local ok = panel:Add( 'DButton' )
	ok:Dock( BOTTOM )
	ok:SetSize( 0, 55 )
	ok:DockMargin( 150, 0, 150, 15)
	ok:SetText( '' )
	ok.Paint = function( _, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, color_okgreen )
		if _:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 30 ) )
		end
		draw.SimpleText( 'OK', 'notify.text', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	

	end

	ok.DoClick = function()
		panel:Remove()
	end

end

net.Receive( 'derma_notify', function()

	local id = net.ReadInt( 3 )
	local title = net.ReadString()
	local text = net.ReadString()

	notify( id, title, text )

end )
