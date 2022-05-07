module( 'gp_warns', package.seeall )


function warns_menu_pl( tbl, warns, sid )

	local frame = vgui.Create( 'DFrame' )
	frame:SetSize( 500, 500 )
	frame:Center()
	frame:MakePopup()
	frame:SetTitle( 'Предупреждения "'..sid..'" | Активных предупреждений: '..warns )
	frame.Paint = function( _, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 220 ) )
		--draw.SimpleText( 'Активных предупреждений: '..warns, 'Trebuchet18', w/2, 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	end

	local warnslist = frame:Add( 'DListView' )
	warnslist:Dock( FILL )
	warnslist:AddColumn( 'Администратор' )
	warnslist:AddColumn( 'Дата' )
	warnslist:AddColumn( 'Причина' )
	warnslist:AddColumn( 'Активность' )
	if LocalPlayer():IsSuperAdmin() then
		warnslist:AddColumn( 'Управление' )
	end

	for k,v in pairs( tbl ) do

		local wl = warnslist:AddLine( v.adm, os.date( "%H:%M:%S - %d/%m/%Y", v.time ), v.reason, v.active and 'Да' or 'Нет' )

		if LocalPlayer():IsSuperAdmin() then
			local btn = wl:Add( 'DButton' )
			btn:SetSize( 25, 15 )
			btn:SetPos( 425, 2.5 )
			btn:SetText( '' )
			btn.Paint = function( _, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0 ) )
				draw.SimpleText( 'X', 'Trebuchet18', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER ) 
			end
			btn.DoClick = function()

				net.Start( 'gp_warns_disa' )
					net.WriteInt( k, 5 )
					net.WriteString( sid )
				net.SendToServer()

				frame:Remove()

			end
		end

	end

end

net.Receive( 'gp_warns_menu', function()

	local tbl = net.ReadTable()
	local warns = net.ReadInt( 5 )
	local sid = net.ReadString()

	warns_menu_pl( tbl, warns, sid )

end )