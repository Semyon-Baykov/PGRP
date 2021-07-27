local function OpenC4Menu( ent )

	local timer_started = ent:GetNWBool( 'c4_timer_started', false )

	local frame = vgui.Create( 'gpFrame' )
	frame:SetSize( 450, 250 )
	frame:Center()
	frame:SetTitle( 'С4' )
	frame:MakePopup()
	frame.PaintOver = function( _, w, h )
		if not timer_started then
			draw.DrawText('Для активации таймера С4 введите\n 4-х значный код: ', 'Trebuchet24', w/2, 40, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.DrawText('Для обезвреживания С4 введите\n 4-х значный код: ', 'Trebuchet24', w/2, 40, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end

	local _1 = frame:Add( 'DNumberWang' )
	_1:SetPos( 110, 115 )
	_1:SetSize( 50, 50 )
	_1:SetFont( 'Trebuchet24' )
	_1:SetMin( 0 )
	_1:SetMax( 9 )
 
	local _2 = frame:Add( 'DNumberWang' )
	_2:SetPos( 110 + 50 + 10, 115 )
	_2:SetSize( 50, 50 )
	_2:SetMin( 0 )
	_2:SetFont( 'Trebuchet24' )
	_2:SetMax( 9 )

	local _3 = frame:Add( 'DNumberWang' )
	_3:SetPos( 110 + 50 + 10 + 50 + 10, 115 )
	_3:SetSize( 50, 50 )
	_3:SetMin( 0 )
	_3:SetFont( 'Trebuchet24' )
	_3:SetMax( 9 )

	local _4 = frame:Add( 'DNumberWang' )
	_4:SetPos( 110 + 50 + 10 + 50 + 10 + 50 + 10, 115 )
	_4:SetSize( 50, 50 )
	_4:SetMin( 0 )
	_4:SetFont( 'Trebuchet24' )
	_4:SetMax( 9 )

	local start = frame:Add( 'gpButton' )
	start:Dock( BOTTOM )
	if not timer_started then
		start:setText( 'Активировать' )
	else
		start:setText( 'Обезвредить' )
	end
	start:SetHeight( 60 )
	start.DoClick = function()

			net.Start( 'gp_c4' )
					net.WriteEntity( ent )
					net.WriteString( _1:GetValue()..''.._2:GetValue()..''.._3:GetValue()..''.._4:GetValue()..'' )
			net.SendToServer()
			frame:Remove()
	end

end

net.Receive( 'gp_c4', function()

		local ent = net.ReadEntity()

		OpenC4Menu( ent )

end )