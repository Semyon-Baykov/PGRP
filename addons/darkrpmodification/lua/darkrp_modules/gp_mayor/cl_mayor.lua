module( 'gp_elections', package.seeall )

surface.CreateFont( 'elections_text', {

	font = 'Rotobo',
	size = 18

} )

local function OpenMenu( tbl )

	local frame = vgui.Create( 'gpFrame' )
	frame:SetSize( 700, 500 )
	frame:Center()
	frame:MakePopup()
	frame:SetTitle( 'Выборы' )

	local ds = frame:Add( 'DScrollPanel' )	
	ds:Dock( FILL )
	ds:DockMargin( 0, 0, 0, 0 )
	ds:GetVBar():SetWide( 3 )
	ds:GetVBar().btnGrip.Paint = function( _, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, color_cgray )
	end

	for k,v in ipairs( tbl ) do
		
		local warped = DarkRP.textWrap( v.str, 'elections_text', 500 )
		surface.SetFont( 'elections_text' )
		local str_size_w, str_size_h = surface.GetTextSize( warped )
		local ply = player.GetByUniqueID(v.id) 

		local _ = ds:Add( 'DPanel' )
		_:Dock( TOP )
		_:DockMargin( 5, 5, 5, 0 )
		_:SetHeight( str_size_h+50 )
		_.Paint = function( _, w, h )

			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 40 ) )

			draw.SimpleText( ply:Nick(), 'Trebuchet24', 10, 10, team.GetColor( ply:Team() ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )

			draw.DrawText( warped, 'elections_text', 15, 35, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )

		end

		local vote = _:Add( 'gpButton' )
		vote:SetSize( 50, 50 )
		vote:SetPos( 620, ((str_size_h+50)/2)-25 )
		vote:setText( '✓' )
		vote.DoClick = function()

			net.Start( 'Elections_vote' )
				net.WriteInt( k, 5 )
			net.SendToServer()
			frame:Remove()

		end

	end

end

net.Receive( 'Elections_menu', function() 
	
	local tbl = net.ReadTable()
	OpenMenu(tbl)

end)

local function OpenJoinMenu()

	local frame = vgui.Create( 'gpFrame' )
	frame:SetSize( 700, 500 )
	frame:Center()
	frame:MakePopup()
	frame:SetTitle( 'Подача кандидатуры на Выборы Мэра' )
	frame.PaintOver = function( _, w, h )

		draw.SimpleText( 'Агитационный материал', 'Trebuchet18', w/2, 45, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

	end

	local dte = frame:Add( 'DTextEntry' )
	dte:Dock( TOP )
	dte:SetTall( 340 )
	dte:SetFont( 'elections_text' )
	dte:SetText( 'Нету..' )
	dte:SetMultiline( true )
	dte:DockMargin( 5, 50, 5, 0 )

	dte.Paint = function( _, w, h )

		surface.SetDrawColor( 0, 0, 0, 200 )
		surface.DrawRect( 0, 0, w, h )
		_:DrawTextEntryText( Color( 255, 255, 255 ), Color( 30, 130, 255 ), Color( 255, 255, 255 ) )

	end

	local button = frame:Add( 'gpButton' )
	button:Dock( BOTTOM )
	button:SetHeight(60)
	button:DockMargin( 5, 0, 5, 5 )
	button:setText( 'Отправить' )
	button.DoClick = function()

		net.Start( 'Elections_join' )
			net.WriteString( dte:GetText() )
		net.SendToServer()

		frame:Remove()

	end

end

net.Receive( 'Elections_joinm', function() 

	OpenJoinMenu()

end)