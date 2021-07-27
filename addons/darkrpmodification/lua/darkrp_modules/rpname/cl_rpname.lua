module( 'gp_rpname', package.seeall )

surface.CreateFont( 'rpname_title', {
	font = 'Roboto',
	size = ScrW()*0.038
} )
surface.CreateFont( 'rpname_text', {
	font = 'Roboto',
	size = 25
} )
surface.CreateFont( 'rpname_n', {
	font = 'Roboto',
	size = 24
} )
surface.CreateFont( 'rpname_te', {
	font = 'Roboto',
	size = 20
} )


function OpenFirstConnectMenu()

	if IsValid( frame ) then
		frame:Remove()
	end

	frame = vgui.Create( 'EditablePanel' )
	frame:SetSize( ScrW(), ScrH() )
	frame:Center()
	frame:MakePopup()

	frame.Paint = function( _, w, h )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( Material( 'ui/bg.png' ) )
		surface.DrawTexturedRect( 0, 0, w, h )
		surface.SetDrawColor( 255, 255, 255, 10 )
		surface.SetMaterial( Material( 'ui/logo165.png' ) )
		surface.DrawTexturedRect( 25, 25, 64, 64 )
	end

	local pnl = frame:Add( 'DPanel' )
	pnl:Dock( FILL )
	pnl:DockMargin( ScrW()/5, ScrH()/7, ScrW()/5, ScrH()/7 )

	pnl.Paint = function( _, w, h )
		draw.SimpleText( 'Добро пожаловать. Снова.', 'rpname_title', w/2, 30, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.DrawText( 'Для начала игры на сервере необходимо придумать \nРП ник для персонажа.', 'rpname_text', w/2, 30+45, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	local npnl = pnl:Add( 'DPanel' )
	npnl:Dock( TOP )
	npnl:SetSize( 0, ScrH()/10 )
	npnl:DockMargin( ScrW()/7, ScrH()/4.6, ScrW()/7, 0 )

	npnl.Paint = function( _, w, h )
		draw.DrawText( 'Имя:', 'rpname_n', w/2, 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	local nt = npnl:Add( 'gpTextEntryA' )
	nt:Dock( BOTTOM )
	nt:SetSize( 0, 40 )
	nt:SetFont( 'rpname_te' )
	nt:SetAlign( 1 )

	local lnpnl = pnl:Add( 'DPanel' )
	lnpnl:Dock( TOP )
	lnpnl:SetSize( 0, ScrH()/10 )
	lnpnl:DockMargin( ScrW()/7, 15, ScrW()/7, 0 )


	lnpnl.Paint = function( _, w, h )
		draw.DrawText( 'Фамилия:', 'rpname_n', w/2, 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	local lnt = lnpnl:Add( 'gpTextEntryA' )
	lnt:Dock( BOTTOM )
	lnt:SetSize( 0, 40 )
	lnt:SetFont( 'rpname_te' )
	lnt:SetAlign( 1 )

	local rand = pnl:Add( 'DButton' )
	rand:Dock( TOP )
	rand:SetSize( 0, 50 )
	rand:SetText( '' )

	rand.Paint = function( _, w, h )
		if _:IsHovered() then
			draw.DrawText( 'Случайно', 'rpname_te', w/2, 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.DrawText( 'Случайно', 'rpname_te', w/2, 20, Color( 170, 170, 170 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end

	rand.DoClick = function()
		local tbl = {}
		http.Fetch( 'https://randus.org/api.php', function( body, len, headers, code )
	        tbl = util.JSONToTable( body )
	        nt:SetValue( tbl['name'][ 'fname' ]['normal'] )
	        lnt:SetValue( tbl['name'][ 'lname']['normal'] )
     	end)
	end

	local play = pnl:Add( 'DButton' )
	play:Dock( TOP )
	play:SetSize( 0, 60 )
	play:SetText( '' )
	play:DockMargin( ScrW()/7, 15, ScrW()/7, 0 )
	
	play.Paint = function( _, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, color_okgreen )
		if _:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 200, 200, 10 ) )
		end
		draw.SimpleText( 'Создать', 'rpname_n', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	play.DoClick = function()
		net.Start( 'gp_rpname.Create' )
			net.WriteString( nt:GetValue() )
			net.WriteString( lnt:GetValue() )
		net.SendToServer()
	end

end


net.Receive( 'gp_rpname.Open', function()

	OpenFirstConnectMenu()

end )