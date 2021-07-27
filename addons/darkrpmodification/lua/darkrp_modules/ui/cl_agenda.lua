surface.CreateFont( 'GPABig', {

	font = 'Roboto',

	size = 25,

	weight = 600

} )


surface.CreateFont( 'GPAMedium', {

	font = 'Roboto',

	size = 22,

	weight = 300

} )

surface.SetFont( 'GPAMedium' )

local w, h = surface.GetTextSize( ' ' )

local agenda = {}

agenda.tsize = 25

agenda.width = ScrW() - ( ScrW() / 1.4 )

agenda.height = agenda.tsize + h * 5 + 5 --ScrH() - ( ScrH() / 1.2 )

agenda.x, agenda.y = ScrW() - 12 - agenda.width, 12

--agenda.csize = agenda.width / 30 -- coreners


local function subtext( text, font )

	local _, count = str:gsub('\n', '\n')

end

hook.Add( 'HUDPaint', 'GPoliceAgenda', function()

	if hook.Call( 'HUDShouldDraw', GAMEMODE, 'DarkRP_Agenda' ) then return end

	local messages = {}

	if GetGlobalBool( 'DarkRP_LockDown' ) then

		local cin = ( math.sin( CurTime() ) + 1 ) / 2

		table.insert( messages, { 'МЭР ОБЪЯВИЛ КОМЕНДАТСКИЙ ЧАС, ПРОЙДИТЕ ДОМОЙ!' , GetGlobalString( 'DarkRP_LockDownReason', '' ) == '' and 'Не указана' or GetGlobalString( 'DarkRP_LockDownReason' ) } )

	end
	/*
	if LocalPlayer():isArrested() then

		local time = string.ToMinutesSeconds( math.Round( ( LocalPlayer():GetNWInt( 'arresttime' ) or 0 ) - ( CurTime() - ( LocalPlayer():GetNWInt( 'arresttimecur' ) or 0 ) ) ) )

		table.insert( messages, { 'ВЫ ПОД АРЕСТОМ!', LocalPlayer():GetNWString( 'arrestreason', '' ) == '' and 'Не указана' or LocalPlayer():GetNWString( 'arrestreason' ), time } )

	end

	if LocalPlayer():isWanted() then

		table.insert( messages, { 'ВАС ОБЪЯВИЛИ В РОЗЫСК!', LocalPlayer():getWantedReason() == '' and 'Не указана' or LocalPlayer():getWantedReason() } )

	end
	*/
	if LocalPlayer():GetNWBool( 'warrant', false ) then

		table.insert( messages, { 'НА ВАС ВЫПИСАН ОРДЕР НА ОБЫСК!', LocalPlayer():GetNWString( 'warrantReason' ) == '' and 'Не указана' or LocalPlayer():GetNWString( 'warrantReason' ) } )

	end


	local y = ( LocalPlayer():getAgendaTable() and agenda.y + agenda.height + 5 or 12 )

	local cin = ( math.sin( CurTime() ) + 1 ) / 2

	local color = Color( cin * 255, 0, 255 - ( cin * 255 ), 255 )

	for mid, message in pairs( messages ) do

		for k, v in pairs( message ) do

			if k == 1 then

				draw.SimpleText( istable( v ) and v[ 1 ] or v, 'GPABig', agenda.x + agenda.width, y, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )

				y = y + h + 3

			else

				draw.SimpleText( v, 'GPAMedium', agenda.x + agenda.width - 25, y, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )


				surface.SetDrawColor( color.r, color.g, color.b, color.a )

		        surface.SetMaterial( Material( 'gportalhud/info.png' ) )

		        surface.DrawTexturedRect( agenda.x + agenda.width - 20, y + 5, 16, 16 )

		        y = y + h + 2

			end

		end

		y = y + 10

		/*draw.SimpleText( v[ 1 ], 'GPABig', agenda.x + agenda.width, ( LocalPlayer():getAgendaTable() and agenda.y + agenda.height or 0 ) + ( ( k - 1 ) * 50 ) + 15, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )

		draw.SimpleText( v[ 2 ], 'GPAMedium', agenda.x + agenda.width - 25, ( LocalPlayer():getAgendaTable() and agenda.y + agenda.height or 0 ) + ( ( k - 1 ) * 50 ) + 40, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )


		surface.SetDrawColor( 255, 255, 255, 255 )

        surface.SetMaterial( Material( 'gportalhud/info.png' ) )

        surface.DrawTexturedRect( agenda.x + agenda.width - 20, ( LocalPlayer():getAgendaTable() and agenda.y + agenda.height or 0 ) + ( ( k - 1 ) * 50 ) + 45, 16, 16 )
	*/
	end


	if not LocalPlayer().getAgendaTable or not LocalPlayer():getAgendaTable() then return end

	-- Background --

	draw.RoundedBox( 0, agenda.x, agenda.y, agenda.width, agenda.height, Color( 0, 0, 0, 150 ) )

	-- Title panel --

	draw.RoundedBox( 0, agenda.x, agenda.y, agenda.width, agenda.tsize, Color( 0, 0, 0, 200 ) )

	-- Outlines --

	draw.RoundedBox( 0, agenda.x, agenda.y, agenda.width, 1.5, Color( 0, 0, 0 ) )

	draw.RoundedBox( 0, agenda.x, agenda.y + agenda.height, agenda.width, 1.5, Color( 0, 0, 0 ) ) 


	draw.RoundedBox( 0, agenda.x, agenda.y, 1.5, agenda.height, Color( 0, 0, 0 ) ) 

	draw.RoundedBox( 0, agenda.x + agenda.width - 1.5, agenda.y, 1.5, agenda.height, Color( 0, 0, 0 ) )

	-- Corners --
	/*
	draw.RoundedBox( 0, agenda.x, agenda.y, agenda.csize, 1.6, Color( 255, 255, 255 ) )

	draw.RoundedBox( 0, agenda.x, agenda.y, 1.6, agenda.csize, Color( 255, 255, 255 ) )


	draw.RoundedBox( 0, agenda.x + agenda.width - agenda.csize, agenda.y, agenda.csize, 1.6, Color( 255, 255, 255 ) )

	draw.RoundedBox( 0, agenda.x + agenda.width, agenda.y, 1.6, agenda.csize, Color( 255, 255, 255 ) )


	draw.RoundedBox( 0, agenda.x, agenda.y + agenda.height, agenda.csize, 1.6, Color( 255, 255, 255 ) )

	draw.RoundedBox( 0, agenda.x, agenda.y + agenda.height - agenda.csize, 1.6, agenda.csize, Color( 255, 255, 255 ) )


	draw.RoundedBox( 0, agenda.x + agenda.width - agenda.csize, agenda.y + agenda.height, agenda.csize, 1.6, Color( 255, 255, 255 ) )

	draw.RoundedBox( 0, agenda.x + agenda.width, agenda.y + agenda.height - agenda.csize, 1.6, agenda.csize, Color( 255, 255, 255 ) )
	*/
	-- Text --

	local text = agenda.text or DarkRP.textWrap( string.gsub( string.gsub( LocalPlayer():getDarkRPVar( 'agenda' ) or '', '//', '\n' ), '\\n', '\n' ), 'GPAMedium', agenda.width - 5 )

	draw.SimpleText( 'Повестка дня', 'GPABig', agenda.x + ( agenda.width ) / 2, agenda.y + ( agenda.tsize ) / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	draw.DrawNonParsedText( text, "GPAMedium", agenda.x + ( agenda.width ) / 2, agenda.y + agenda.tsize, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )

end )


hook.Add( 'DarkRPVarChanged', 'GPoliceAgenda', function( ply, var, _, text )

	if ply != LocalPlayer() then return end

	if var == 'agenda' and new then

		agenda.text = DarkRP.textWrap( string.gsub( string.gsub( text, '//', '\n' ), '\\n', '\n' ), 'DarkRPHUD1', agenda.width - 20 )

	end

end )